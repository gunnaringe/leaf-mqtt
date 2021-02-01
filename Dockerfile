FROM pypy:3
WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY leaf-python-mqtt.py leaf-python-mqtt.py

ENTRYPOINT [ "pypy", "leaf-python-mqtt.py" ]
