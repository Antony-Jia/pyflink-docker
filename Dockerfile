FROM flink:1.15.2

# install python3: it has updated Python to 3.9 in Debian 11 and so install Python 3.7 from source
# it currently only supports Python 3.6, 3.7 and 3.8 in PyFlink officially.

# COPY ./sources.list /etc/apt/sources.list

# RUN cat /etc/apt/sources.list
# RUN rm -Rf /var/lib/apt/lists/*


RUN apt-get update -y && apt-get upgrade -y &&\
apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libffi-dev sqlite3 libsqlite3-dev && \
wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz && \
tar -xvf Python-3.7.9.tgz && \
cd Python-3.7.9 && \
./configure --enable-loadable-sqlite-extensions --without-tests --enable-shared && \
make -j6 && \
make install && \
ldconfig /usr/local/lib && \
cd .. && rm -f Python-3.7.9.tgz && rm -rf Python-3.7.9 && \
ln -s /usr/local/bin/python3 /usr/local/bin/python && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# install PyFlink


RUN pip3 install -i https://pypi.douban.com/simple/ -U pip && \
pip3 config set global.index-url https://pypi.douban.com/simple/

COPY apache-flink*.tar.gz /
RUN pip3 install /apache-flink-libraries*.tar.gz && pip3 install /apache-flink*.tar.gz && pip3 install jupyter

# jupyter notebook --allow-root --port=8888 --ip='*' --NotebookApp.token='' --NotebookApp.password='' &