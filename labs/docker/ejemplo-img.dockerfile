FROM python:latest
RUN echo "Hola \n el espacio en disco es `du -sh /`"
CMD [ "python version" ]