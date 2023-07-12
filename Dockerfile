FROM ppodgorsek/robot-framework:latest

USER root
RUN dnf install -y git
COPY requirements.txt requirements.txt
RUN pip3 install --upgrade pip && pip install --no-cache-dir -r requirements.txt

USER ${ROBOT_UID}:${ROBOT_GID}


COPY ./op_robot_tests/tests_files  /opt/robotframework/tests
COPY ./robot_tests_arguments  /opt/robotframework/robot_tests_arguments

CMD ["sh","-c", "run-tests-in-virtual-screen.sh"]
