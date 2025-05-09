# Stage 1: Build the Go app
FROM golang:1.22-alpine AS builder

# Set the working directory inside the builder container
WORKDIR /usr/src/app

# Copy all files from your host to the container
COPY . .

# Download Go module dependencies
RUN go mod download

# Build the Go application binary
RUN go build -o product-catalog ./

# Stage 2: Create a minimal production image
FROM alpine AS release

# Set the working directory in the release image
WORKDIR /usr/bin/app

# Copy any runtime data needed by the app (e.g., product data)
COPY ./products ./products

# Copy the compiled binary from the builder stage
COPY --from=builder /usr/src/app/product-catalog ./

# Set environment variable (optional, but good practice)
ENV PRODUCT_CATALOG_PORT=8088

# Define the command to run when the container starts
ENTRYPOINT ["./product-catalog"]

