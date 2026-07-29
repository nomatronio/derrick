FROM ruby:2.7-slim

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "ruby", "app.rb", "-o", "0.0.0.0", "-p", "3000"]
