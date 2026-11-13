FROM mcr.microsoft.com/devcontainers/python:3.12-bookworm

# Set app dir
WORKDIR /app

# Copy and install dependencies (optional corporate PyPI feed via --build-arg)
ARG PIP_INDEX_URL
COPY requirements.txt .
RUN pip install -r requirements.txt \
    # Corporate feeds can serve sdist metadata without Requires-Dist (e.g. literalai),
    # so pip skips its dependencies. A second pass resolves them from the built wheel's metadata.
    && pip install -r requirements.txt \
    && pip check

# Copy app code
COPY . .
RUN pip install --no-deps .

# Expose port 8080
EXPOSE 8080

# Launch via Uvicorn (main.py configures CHAINLIT_AUTH_SECRET before importing Chainlit)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
