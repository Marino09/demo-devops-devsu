FROM python:3.11-slim

# env vars
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

# user & group non root
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app
COPY requirements.txt .

RUN pip install --no-cache-dir --progress-bar off -r requirements.txt

COPY . .

USER appuser

EXPOSE 8000

# apply migrations and run the server 
# I added the --nothreading flag because I was having some
# trouble with runserver managing multithreading, this is
# the best solution without altering the request.txt.
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000 --noreload --nothreading"]

