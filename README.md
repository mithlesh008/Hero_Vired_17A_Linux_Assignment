# Linux User Management and File Permissions Lab

## Overview

This lab demonstrates essential Linux system administration tasks, including:

* Directory creation and management
* File creation and configuration
* Permission management
* Ownership modification
* Shell scripting
* User and group administration
* Access control verification

The exercise builds a small application directory structure, creates a logging script, and validates user/group permissions.

---

## Prerequisites

* Linux server (Amazon Linux, RHEL, CentOS, Ubuntu, etc.)
* Sudo privileges
* Bash shell
* Vim editor installed

---

## Question 1

# Step 1: Create Application Directory Structure

- Create the /home/ec2-user/webapp/ directory with the required subdirectories and files, then apply the correct permissions and ownership.

```bash
mkdir -p /home/ec2-user/webapp/{scripts,logs,config}
```

---

# Step 2: Create Configuration File

Create the application configuration file:

```bash
cat > /home/ec2-user/webapp/config/app.conf
```

## Example content:

```ini
APP_NAME=WebApp
PORT=8080
```

Press:

```text
Ctrl + D
```

to save the file.

## Explanation
  - cat > file allows you to type content directly into a file
  - APP_NAME=WebApp defines the application name
  - PORT=8080 defines the port number for the application



---

# Step 3: Create Empty Log File

```bash
touch /home/ec2-user/webapp/logs/app.log
ls -l /home/ec2-user/webapp/logs/app.log
```

## Explanation
  - `touch` creates an empty file if it does not exist
  - `ls -l` shows detailed file information
  - A size of 0 confirms that the log file is empty

- **Example output**:
```
-rw-r--r-- 1 ec2-user ec2-user 0 May 31 10:00 /home/ec2-user/webapp/logs/app.log
```
---

# Step 4: Configure Permissions

- Set directory permissions:

```bash
chmod 755 /home/ec2-user/webapp/scripts
```

- Set configuration file permissions:

```bash
chmod 644 /home/ec2-user/webapp/config/app.conf
```

## Permission Explanation

### `chmod 755`

755 means:

- **Owner = 7 = read, write, execute**
- **Group = 5 = read, execute**
- **Others = 5 = read, execute**

So for the `scripts/` directory:

- Owner can read, modify, and enter the directory
- Group can read and enter the directory
- Others can read and enter the directory

For directories, **execute permission** means the user can access or enter the directory.

---

### `chmod 644`

644 means:

- **Owner = 6 = read, write**
- **Group = 4 = read only**
- **Others = 4 = read only**

So for `app.conf`:

- Owner can read and edit the file
- Group can only read the file
- Others can only read the file


---

# Step 5: Change Ownership

Recursively assign ownership to root:

```bash
sudo chown -R root:root /home/ec2-user/webapp/
```
## Explanation

* `chown` changes ownership.
* `-R` means **recursive**, so the change applies to all files and subdirectories inside `webapp/`.
* `root:root` means:
  * The **owner** becomes `root`.
  * The **group** becomes `root`.


---

# Step 6: Verify Directory Structure

```bash
ls -lR /home/ec2-user/webapp/
```

Expected structure:

```text
webapp/
├── config/
│   └── app.conf
├── logs/
│   └── app.log
└── scripts/
```

<img width="845" height="474" alt="Screenshot 2026-05-31 at 9 46 16 AM" src="https://github.com/user-attachments/assets/17243fb2-8648-42eb-9607-b3cec27e11e5" />

---

## Question 2

# Step 1: Create Logging Script

Create the script:

```bash
vim /home/ec2-user/webapp/scripts/log_user.sh
```

Press:

```text
i
```

Insert the following script:

```bash
#!/bin/bash
read -p "Enter your name: " username
cat /home/ec2-user/webapp/config/app.conf
echo "Login: $username Date: $(date)" >> /home/ec2-user/webapp/logs/app.log
cat /home/ec2-user/webapp/logs/app.log
```

Save and exit Vim:

```text
Esc
:wq
```

<img width="1075" height="185" alt="Screenshot 2026-05-31 at 9 48 05 AM" src="https://github.com/user-attachments/assets/b93bc790-d7a8-488b-821f-82092d6787d1" />

## Explanation

### `#!/bin/bash`

This is the **shebang line**.

It tells Linux to run the script using the **Bash shell**.

---

### `read -p "Enter your name: " username`

- `read` accepts input from the user  
- `-p` displays a prompt message  
- `username` stores the value entered by the user  

If the user types **Chirag**, then `username = Chirag`.

---

# Step 2: Make Script Executable

```bash
chmod +x /home/ec2-user/webapp/scripts/log_user.sh
```

## Explanation

- `chmod +x` adds execute permission.

- This allows the file to be run as a script.

Verify:

```bash
ls -l /home/ec2-user/webapp/scripts/log_user.sh
```

---

# Step 3: Execute Script

Run the script three times:

```bash
for i in {1..3}; do /home/ec2-user/webapp/scripts/log_user.sh; sleep 2; i=`expr $i + 1` ; done
```

## Example Inputs

Use three different names such as:

- Chirag  
- Priya  
- Ravi

  <img width="1699" height="476" alt="Screenshot 2026-05-31 at 9 54 35 AM" src="https://github.com/user-attachments/assets/089ca119-03fc-4587-859f-70e8cf98ac5c" />

---

# Step 4: Verify Log Entries

Display the log file:

```bash
cat /home/ec2-user/webapp/logs/app.log
```

Example output:

```text
Login: Chirag Date: Sun May 31 04:23:51 AM UTC 2026
Login: Priya Date: Sun May 31 04:23:55 AM UTC 2026
Login: Ravi Date: Sun May 31 04:23:59 AM UTC 2026
```

---

## Question 3

# Step 1: Create Writers Group

```bash
# sudo groupadd writers
```

Verify:

```bash
# getent group writers
writers:x:1003:devuser1,devuser2
```

## Explanation
- `groupadd` creates a new Linux group.
- This group will be used for users who need write access to the script.

---

# Step 2: Create Users and add to group `writers`

- Create four users using Bash Script and Add Users to `Writers` Group:

```bash
# vim users.sh
# cat users.sh

#!/bin/bash
sudo groupadd writers
for i in {1..4}
do 
	sudo useradd -m devuser$i
	i=`expr $i + 1`
done

for j in {1..2}
do
	sudo usermod -aG writers devuser$i
	j=`expr $j + 1`
done

sudo chown root:writers /home/ec2-user/webapp/scripts/log_user.sh
sudo chmod 664 /home/ec2-user/webapp/scripts/log_user.sh

```

## Explanation

This Script will do the following using `for` loop:
- `useradd` creates a user.  
- `-m` creates a home directory automatically.  
- `usermod` modifies an existing user.  
  - `-aG` means append the user to a supplementary group.  
  - Both `devuser1` and `devuser2` are added to `writers`.
  - Owner to `root`  
  - Group to `writers`  

- So the script is now owned by:
  - User: `root`  
  - Group: `writers`  

These two users will inherit the group permissions of files owned by the `writers` group.

**Permission breakdown**:

| Permission | Meaning      |
| ---------- | ------------ |
| Owner (6)  | Read + Write |
| Group (6)  | Read + Write |
| Others (4) | Read Only    |

So for `log_user.sh`:

- Root can read and write  
- Members of `writers` can read and write  
- All other users can only read

- **Verify Permissions**:

```bash
ls -l /home/ec2-user/webapp/scripts/log_user.sh
```

- **Expected Output**:
```
-rw-rw-r-- 1 root writers 207 May 31 04:17 /home/ec2-user/webapp/scripts/log_user.sh
```

# Step 3: Verify

Verify membership:

```bash
cat /etc/passwd | grep devuser
```

<img width="1728" height="203" alt="Screenshot 2026-05-31 at 10 21 55 AM" src="https://github.com/user-attachments/assets/ac2e4928-9c2c-4029-91dc-159bf5ad470c" />

```bash
# groups devuser1
devuser1 : devuser1 writers

# groups devuser2
devuser2 : devuser2 writers
```
---

# Step 4: Test Group Write Access

Switch to a group member:

```bash
su - devuser1
```

Append content:

```bash
echo 'test' >> /home/ec2-user/webapp/scripts/log_user.sh
```

Expected result:

```text
Success
```

Repeat for:

```bash
devuser2
```

### This will work if:
`devuser1` and `devuser2` has write permission on log_user.sh. The file exists and is writable by `writers` group's member.

---

# Step 5: Test Read-Only Access

Switch to a non-group user:

```bash
su - devuser3
```

Read the script:

```bash
cat /home/ec2-user/webapp/scripts/log_user.sh
```

Expected result:

```text
Success
```

Attempt to write:

```bash
echo 'test' >> /home/ec2-user/webapp/scripts/log_user.sh
```

Expected result:

```text
-bash: /home/ec2-user/webapp/scripts/log_user.sh: Permission denied
```

Repeat for:

```bash
devuser4
```

---

# Learning Outcomes

After completing this lab, you will understand:

* Linux file permissions (`chmod`)
* Ownership management (`chown`)
* Group administration (`groupadd`, `usermod`)
* User creation (`useradd`)
* Recursive ownership changes
* Shell script creation using Vim
* File access control
* Permission verification and testing

---

**Note**: If a user has write (w) permission on a file, they can modify it even if they do not have execute (x) permission on that file.
