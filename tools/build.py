import _globals
import _helpers
import subprocess
import sys


args = _helpers.process_args(sys.argv)
config = _helpers.get_arg_value(args, ["config", "c"], _globals.BUILD_CFG)
project = _helpers.get_arg_value(args, ["project", "p"], _globals.BUILD_PRJ_NAME)

exit_code = 0
if _globals.PLATFORM == "linux":
    process = subprocess.run(["make", "config={}".format(config.lower())]) # make uses lowercase config regardless of what is in premake5
    exit_code = process.returncode
elif _globals.PLATFORM == "windows":
    process = subprocess.run(["msbuild", "/property:Configuration={}".format(config)])
    exit_code = process.returncode

metaDataFile = "{}/{}.build.meta".format(project, project)
currentVersion = _helpers.read_version(metaDataFile)
build_meta = open(metaDataFile, 'w')
versioning_meta = ["MAJOR {}\n".format(currentVersion.MAJOR), "MINOR {}\n".format(currentVersion.MINOR), "PATCH {}\n".format(currentVersion.PATCH), "BUILD {}".format(currentVersion.BUILD + 1)]
build_meta.writelines(versioning_meta)
build_meta.close()

sys.exit(exit_code)
