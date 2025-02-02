FROM python:3.9.1

RUN pip install jupyter pandas sqlalchemy psycopg2-binary jupyter_contrib_nbextensions

WORKDIR /home/jovyan/work

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
