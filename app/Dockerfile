FROM ruby:2.7
RUN git clone https://github.com/RNDcpp/mecab_services_pb
COPY ./Gemfile Gemfile
RUN bundle install
WORKDIR /app
CMD bundle install
