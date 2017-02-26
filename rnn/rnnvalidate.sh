#!/bin/bash
find ../rnndb/ -name "*.xml" -type f | xargs -- xmllint --noout --schema ../rnndb/rules-ng-ng.xsd
