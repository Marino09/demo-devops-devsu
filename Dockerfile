FROM python:3.11-slim

WORKDIR /app

# dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --progress-bar off -r requirements.txt

COPY . .

# env vars
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PORT=8000

EXPOSE 8000

# apply migrations and run the server 
# I added the --nothreading flag because I was having some
# trouble with runserver managing multithreading, this is
# the best solution without altering the request.txt.
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000 --noreload --nothreading"]

