!#/bin/bash

# Configuration
TARGET_URL="10.10.11.11"
HEADERS="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWbKit/537.36 (KKTML, like Geecko) Chrome/58.0.3029.110 Safari/537.3"
LOG_FILE="security_test_results.log"

# Utility function
log_result() {
	echo "$1" >> "$LOG_FILE"
	echo "$1" 
}

# Function to test Cross-Site-Scripting (XSS)
test_xss() {
	PAYLOAD="<script>alert/'XSS')</scipt>"
	RESPONSE=$(curl -s -G -A "$Headers" --data-urlencode "q=$PAYLOAD" "$TARGERT_URL")
	if echo "$RESPONSE" | grep -q "$PAYLOAD"; then
		log_result "[XSS] Vulnerable URL: $TARGET_URL?q=$PAYLOAD"
	else
		log_result "[XSS] No vulnerability found at: $TARGERT_URL"
	fi
}

# Function to test SQL-Injection
test_sql_injection() {
	PAYLOAD"' OR '1' = '1"
	RESPONSE=$(curl -s -G -A "$HEADERS" --data-urlencode "q=$PAYLOAD" "TARGERT_URL")
	if echo "$RESONSE" | grep -iq "error\|sytax"; then
		log_result " [SQL Injection] Vulnerable URL: $TARGERT_URL?=q=$PAYLOAD"
	else 
		log_result "[SQL Injection] No vulnerability found at: $TARGET_URL"
	fi
}

# Function to test Cross-Site-Request Forgery (CSRF)
test_csrf() {
	RESPONSE=$(curl -s -A "$HEADERS" "TARGET_URL/from")
	if ! echo "$RESONSE" | grep -q "csrf_token"; then
		log_result "[CSRF] Vulnerable URL: $TARGET_URL/from"
	else
		log_result "[CSRF] No vulnerability found at: $TARGET_URL/from"
	fi
}

# Function to tst broken Authentification
test_authentification() {
	RESPONSE=$(curl -s -X POST -A "$HEADERS" -d "username=admin&password=admin" "TARGERT_URL/login")
	if echo "$RESPONSE" | grep -iq "welcome"; then
		log_result "[Broken Authentification] Vulnarable URL: $TARGET_URL/login"
	else
		log_result "[Broken Authentification] No Vulnerability found at: $TARGET_URL/login"
	fi
}

# Function to test Security Misconfiguration
test_security_headers() {
	RESPONSE=$(curl -s -I -A "$HEADERS" "TARGET_URL")
	if ! echo "$RESPONSE" | grep -q "X-Frame-Options"; then
		log_result "[Security Misconfiguration] X-Frame_Options header missing at: $TARGET_URL"
	else
		log_result "[Security Misconfiguration] X-Frame-Operator present at: $TARGET_URL"
	fi
}

# Function to test Sensitiive Data Exposure
test_sensitive_data() {
	RESPONSE=$(curl -s -A "$HEADERS" "$TARGET_URL")
	if echo "$RESPONSE" | grep -iq "password\|credit card"; then
		log_result "[Sensitive Data Exposure] Sensitive Data found at: $TARGET_URL"
	else
		log_result "[Sensitive Date Exposure] No sensitive Data found at: $TARGET_URL"
	fi
}

# Function to test Insecure Deserialization
test_deserialization() {
	PAYLOAD='{"username":"admin","password":"admin"}'
	RESPONSE=$(curl -s -X POST -A "$HEADERS" -d "$PAYLOAD" "$TARGET_URL/api")
	if ! echo "$RESPONSE" | grep -iq "error"; then
		log_result "[Insecure Deserializaton] Vulnerable URL: $TARGET_URL/api"
	else
		log_result "[Insecure Deserilization] No vulnerability found at: $TARGET_URL/api"
	fi
}

# Function t test Security Headers
test_headers() {
	RESPONSE=$(curl -s -I -A "$HEADERS" "$TARGET_URL")
	SECURITY_HEADERS=("Content-Security-Policy" "X-Content-Type-Options" "X-Frame-Options")
	for header in "${SECURITY_HEADERS[@]}"; do
		if ! echo "$RESPONSE" | grep -q "$header"; then
			log_result "[Security Headers] $header missing at: $TARGET_URL"
		else
			log_result "[Security Header] $header present at: $TARGET_URL"
		fi
	done
}

# Execute all tests
echo "Starting web application security tests for $TARGET_URL" > "$LOG_FILE"
test_xss
test_sql_injection
test_csrf
test_authentification
test_security_headers
test_sensitive_data
test_deserialization
test_headers
echo "Web application security tests completed for $Target_URL" >> "$LOG_FILE"
