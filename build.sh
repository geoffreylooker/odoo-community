# The Google App Engine base image is debian (jessie) with ca-certificates
# installed.
# Source: https://github.com/GoogleCloudPlatform/debian-docker
#FROM gcr.io/google-appengine/debian8

#ADD resources /resources
#ADD scripts /scripts

# Install Python, pip, and C dev libraries necessary to compile the most popular
# Python libraries.
./scripts/install-apt-packages.sh

# Setup locale. This prevents Python 3 IO encoding issues.
#ENV LANG C.UTF-8
# Make stdout/stderr unbuffered. This prevents delay between output and cloud
# logging collection.
#ENV PYTHONUNBUFFERED 1

# Upgrade pip (debian package version tends to run a few version behind) and
# install virtualenv system-wide.
pip install --upgrade pip virtualenv pysftp

# Install the Google-built interpreters
#ADD interpreters.tar.gz /

# Add Google-built interpreters to the path
#ENV PATH /opt/python3.5/bin:$PATH

# Setup the app working directory
#RUN ln -s /home/vmagent/app /app
#WORKDIR /app

# Port 8080 is the port used by Google App Engine for serving HTTP traffic.
#EXPOSE 8080
#ENV PORT 8080

# The user's Dockerfile must specify an entrypoint with ENTRYPOINT or CMD.
#CMD []

#########################

# create and activate a virtualenv
#virtualenv venv
#. ./venv/bin/activate

# install Odoo 10.0 nightly
#pip install -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt
#pip install https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.zip

# check installed packages
python -c "import odoo" ; || exit $?
pip list | grep odoo ;

# install base_import_async from wheelhouse.odoo-community.org
#pip install odoo-addon-base_import_async --find-links=https://wheelhouse.odoo-community.org/oca-10.0

# start odoo
#odoo




