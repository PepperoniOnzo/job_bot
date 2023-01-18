# Dart SDK
FROM dart:stable AS build

# App dependencies
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# App source
COPY . .
# Ensure packages are up to date
RUN dart pub get --offline

# Build the app
RUN dart compile exe bin/job_bot.dart -o bin/server

# Build the runtime image
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Run the app
CMD ["/app/bin/server"]
