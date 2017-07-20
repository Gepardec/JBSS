#!/usr/bin/python

DOCUMENTATION = '''
---
module: wildfly_install
short_description: Installs JBoss WildFly or EAP.
description: Unpacks a JBoss ZIP-file to JBoss Home an removes the first directory (version-name)
'''

EXAMPLES = '''
- name: Show deployments
  wildfly_install:
    zip: /tmp/jboss-eap-7.0.0.zip
    jboss_home: /home/jboss/myjboss
'''

RETURN = '''
result:
    description: Output of command
    returned: success
    type: string
    sample: xxx
'''

ANSIBLE_METADATA = {'metadata_version': '1.0',
                    'status': ['preview'],
                    'supported_by': 'community'}

from ansible.module_utils.basic import AnsibleModule
import os
import zipfile
import shutil

__author__ = 'Erhard Siegl'

# Global variables

def install(data):

    is_error = False
    has_changed = False

    src =  data['zip']
    dest =  data['jboss_home']
    is_error, result = check(src, dest)
    if not is_error:
      is_error, result = unzip(src, dest)
    if not is_error:
      has_changed = True
      is_error, result = remove_version_dir(dest)

    if not is_error:
      result = "JBoss installed"

    resp = {
        "result": result
    }
    if is_error:
        meta = {"status" : "FAILED", "response" : resp}
    else:
        meta = {"status" : "OK", "response" : resp}

    return is_error, has_changed, meta

def check( zip, jboss_home):
    if not os.path.isfile( zip):
      return True, "zip-file must exist: " + zip
    if os.path.exists( jboss_home):
      return True, "jboss_home must not exist. Use: rm -rf " + jboss_home
    return False, "Prerequisites seem OK"

def unzip( zip, dest):
    zip_ref = zipfile.ZipFile(zip, 'r')
    try:
      for info in zip_ref.infolist():
        real_path = zip_ref.extract(info, dest)

        # permission
        unix_attributes = info.external_attr >> 16
        target = os.path.join(dest, info.filename)
        if unix_attributes:
            os.chmod(target, unix_attributes)

        if not real_path:
            return True, "Extract failed: " + info.filename
    finally:
      zip_ref.close()
    return False, "Unzipped " + zip

def remove_version_dir( dest):
    moved = False
    for file in os.listdir(dest):
      file = os.path.join( dest, file)
      if os.path.isdir(file):
        move_files(file, dest)
        shutil.rmtree(file)
        moved = True
      else:
        print "Error: Sollte directory sein: " + file
    if not moved:
      return True, "Something was wrong with the package, was empty? Directory: " + dest
    return False, "Files moved"

def move_files( dir, dest):
    for file in os.listdir(dir):
      file = os.path.join( dir, file)
      shutil.move(file, dest)

def main():
    fields = {
        "zip": {
            "required": True,
            "type": "str"
        },
        "jboss_home": {
            "required": True,
            "type": "str"
        },
    }

    module = AnsibleModule(argument_spec=fields)

    is_error, has_changed, result = install(module.params)

    if not is_error:
        module.exit_json(changed=has_changed, meta=result)
    else:
        module.fail_json(msg="Error installing WildFly", meta=result)

if __name__ == '__main__':
    main()

