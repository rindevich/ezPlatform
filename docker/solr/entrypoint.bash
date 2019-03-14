#!/usr/bin/env bash

DESTINATION_EZ="/ezsolr/server/ez"
DESTINATION_TEMPLATE="$DESTINATION_EZ/template"
SOLR_PATH_CONFIGURATION="vendor/ezsystems/ezplatform-solr-search-engine/lib/Resources/config/solr/"

rm -rf DESTINATION_EZ
mkdir -p DESTINATION_EZ

cd /var/www/html

while true
do
  [ -d ${SOLR_PATH_CONFIGURATION} ] && break
    echo "eZPlatform Solr Cores Configuration waiting ...."
    sleep 30
done

if [ ! -d ${DESTINATION_TEMPLATE} ]; then
    mkdir -p $DESTINATION_TEMPLATE
    cp -R ${SOLR_PATH_CONFIGURATION}/* $DESTINATION_TEMPLATE
fi

if [ ! -f ${DESTINATION_EZ}/solr.xml ]; then
    cp /opt/solr/server/solr/solr.xml /ezsolr/server/ez
    cp /opt/solr/server/solr/configsets/basic_configs/conf/{currency.xml,solrconfig.xml,stopwords.txt,synonyms.txt,elevate.xml} /ezsolr/server/ez/template
    sed -i.bak '/<updateRequestProcessorChain name="add-unknown-fields-to-the-schema">/,/<\/updateRequestProcessorChain>/d' /ezsolr/server/ez/template/solrconfig.xml
    sed -i -e 's/<maxTime>${solr.autoSoftCommit.maxTime:-1}<\/maxTime>/<maxTime>${solr.autoSoftCommit.maxTime:20}<\/maxTime>/g' /ezsolr/server/ez/template/solrconfig.xml
    sed -i -e 's/<dataDir>${solr.data.dir:}<\/dataDir>/<dataDir>\/opt\/solr\/data\/${solr.core.name}<\/dataDir>/g' /ezsolr/server/ez/template/solrconfig.xml
fi

echo "Start solr on background to create missing cores"
/opt/solr/bin/solr -s ${DESTINATION_EZ}

for core in $SOLR_CORES
  do
      if [ ! -d ${DESTINATION_EZ}/${core} ]; then
            /opt/solr/bin/solr delete -c ${core}
            /opt/solr/bin/solr create_core -c ${core}  -d ${DESTINATION_TEMPLATE}
            echo "Core ${core} created."
      fi
  done

echo "Stop background solr"
/opt/solr/bin/solr stop
/opt/solr/bin/solr -s ${DESTINATION_EZ} -f
