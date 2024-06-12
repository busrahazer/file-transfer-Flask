from flask import Flask, request, jsonify
import paramiko
import os

app = Flask(__name__)

@app.route('/download_log', methods=['POST'])
def download_log():
    data = request.get_json()
    remote_host = data.get('remote_host')
    remote_port = data.get('remote_port', 22)
    username = data.get('username')
    remote_path = data.get('remote_path')
    key_file = os.path.expanduser("~/.ssh/id_rsa")

    # Validate input
    if not (remote_host and username and remote_path):
        return jsonify({"message": "Missing required fields", "status": "error"})

    try:
        # Establish SSH connection
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(remote_host, port=remote_port, username=username, key_filename=key_file)

        # SFTP to download files
        sftp = ssh.open_sftp()
        local_path = os.path.join(os.getcwd(), 'bana_yukle')
        if not os.path.exists(local_path):
            os.makedirs(local_path)

        files = sftp.listdir(remote_path)
        for file in files:
            if file.startswith('log-') and file.endswith('.log'):
                sftp.get(os.path.join(remote_path, file), os.path.join(local_path, file))

        sftp.close()
        ssh.close()
        return jsonify({"message": "Logs downloaded successfully", "status": "success"})
    except paramiko.ssh_exception.NoValidConnectionsError as e:
        return jsonify({"message": f"Unable to connect to {remote_host} on port {remote_port}: {e}", "status": "error"})
    except paramiko.ssh_exception.AuthenticationException as e:
        return jsonify({"message": f"Authentication failed for {username}@{remote_host}: {e}", "status": "error"})
    except FileNotFoundError as e:
        return jsonify({"message": f"File not found: {e}", "status": "error"})
    except PermissionError as e:
        return jsonify({"message": f"Permission denied: {e}", "status": "error"})
    except Exception as e:
        return jsonify({"message": str(e), "status": "error"})

if __name__ == '__main__':
    app.run(debug=True)
