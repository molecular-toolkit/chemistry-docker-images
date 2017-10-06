FROM nwtoo
COPY run.sh run.py getresults.py /usr/bin/
RUN chmod +x /usr/bin/getresults.py /usr/bin/run.py /usr/bin/run.sh
ENTRYPOINT
CMD
RUN apt-get install -y python-dev git make
ENV NWCHEMFILE 6.6
RUN git clone https://github.com/NWChem-Python/nwapi \
     && cd nwapi \
     && git checkout memory  \
     && make -f makefile.linux \
     && python setup.py install


