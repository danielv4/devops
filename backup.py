# Author: Daniel Vanderloo <marss6414@gmail.com>
import tarfile
import os.path
from datetime import date
import errno


# 7.1 Makes backup of the "var/www" directory
# 7.2 Makes sure that a backup directory exists before performing the backup operation. Backup directory should be "/var/lib/backups".


def mkdir(path):
    try:
        os.makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise


def backup():

    source_dir = "/var/www/"
    today = str(date.today())
    filename = "/var/lib/backups/www-backup-" + today + ".tar.gz"
    
    if os.path.exists(filename) == False:
        with tarfile.open(filename, "w:gz") as tar:
            tar.add(source_dir, arcname=os.path.basename(source_dir))


mkdir("/var/www/")
mkdir("/var/lib/backups")
backup()