#!/bin/bash
 
# Set variables
URL="http://192.168.1.1:8081"
Token="X-Api-Key: $YOURTOKEN"
uuid="$YOURUUID"
current_date=$(date +%F)
 
# Use variables in curl command
curl -H "$Token" -X GET "$URL/api/v1/finding/project/$uuid/export" -o result.json
 
# Generate CSV file from JSON response, sorted by severity
jq -r '[
    "alternateIdentifier", "attributedOn", "referenceUrl", "group",
    "latestVersion", "name", "project", "purl", "version", "description",
    "epssPercentile", "epssScore", "severity", "severityRank", "source", "vulnId"
],
(.findings | sort_by(.vulnerability.severity)[] | [
    .attribution.alternateIdentifier,
    .attribution.attributedOn, .attribution.referenceUrl, .component.group, .component.latestVersion,
    .component.name, .component.project, .component.purl, .component.version,
    .vulnerability.description, .vulnerability.epssPercentile,
    .vulnerability.epssScore, .vulnerability.severity, .vulnerability.severityRank, .vulnerability.source,
    .vulnerability.vulnId
]) | @csv' result.json > "dt-result-${current_date}.csv"
