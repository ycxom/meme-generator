FROM python:3.10 AS tmp

WORKDIR /tmp

RUN curl -sSL https://install.python-poetry.org | python -

ENV PATH="${PATH}:/root/.local/bin"

COPY ./pyproject.toml ./poetry.lock* /tmp/

RUN poetry self add poetry-plugin-export \
  && poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.10-slim AS app

WORKDIR /app

EXPOSE 2233

VOLUME /data

ENV TZ="Asia/Shanghai" \
  LOAD_BUILTIN_MEMES="true" \
  MEME_DIRS="[\"/data/memes\"]" \
  MEME_DISABLED_LIST="[]" \
  GIF_MAX_SIZE="10.0" \
  GIF_MAX_FRAMES="100" \
  LOG_LEVEL="INFO" \
  TRANSLATE_TYPE="baidu" \
  TRANSLATE_BAIDU_APPID="" \
  TRANSLATE_BAIDU_APIKEY="" \
  TRANSLATE_OPENAI_API_KEY="" \
  TRANSLATE_OPENAI_URL="https://api.openai.com/v1/chat/completions" \
  TRANSLATE_OPENAI_MODEL="gpt-4o" \
  TRANSLATE_GEMINI_API_KEY="" \
  TRANSLATE_GEMINI_API_BASE="https://generativelanguage.googleapis.com" \
  TRANSLATE_GEMINI_MODEL="gemini-2.0-flash"

COPY --from=tmp /tmp/requirements.txt /app/requirements.txt

COPY ./resources/fonts/* /usr/share/fonts/meme-fonts/

RUN apt-get update \
  && apt-get install -y --no-install-recommends fontconfig fonts-noto-color-emoji libgl1-mesa-glx libgl1-mesa-dri libegl1-mesa gettext \
  && fc-cache -fv \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./meme_generator /app/meme_generator

COPY ./docker/config.toml.template /app/config.toml.template
COPY ./docker/start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]