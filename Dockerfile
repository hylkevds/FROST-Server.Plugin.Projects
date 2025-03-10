FROM fraunhoferiosb/frost-server-http:2.4

COPY data ${CATALINA_HOME}/webapps/FROST-Server/WEB-INF/data
COPY index.html ${CATALINA_HOME}/webapps/FROST-Server/

ENV plugins_coreModel_enable=true
ENV plugins_actuation_enable=false
ENV plugins_multiDatastream_enable=false
ENV plugins_openApi_enable=true
ENV plugins_odata_enable=true
ENV plugins_csv_enable=true
ENV plugins_geojson_enable=true
ENV plugins_modelLoader_enable=true
ENV plugins_modelLoader_modelPath='/usr/local/tomcat/webapps/FROST-Server/WEB-INF/data/model'
ENV plugins_modelLoader_modelFiles='Project.json, Restricted.json, Role.json, User.json, UserProjectRole.json'
ENV plugins_modelLoader_securityPath='/usr/local/tomcat/webapps/FROST-Server/WEB-INF/data/security'
ENV plugins_modelLoader_securityFiles='secDatastream.json, secFeature.json, secHistoricalLocation.json, secLocation.json, secObservation.json, secProject.json, secRole.json, secSensor.json, secThing.json, secUser.json, secUserProjectRole.json'
ENV plugins_modelLoader_liquibasePath='/usr/local/tomcat/webapps/FROST-Server/WEB-INF/data/liquibase'
ENV plugins_modelLoader_liquibaseFiles='tables.xml'
ENV plugins_modelLoader_idType_Role='STRING'
ENV plugins_modelLoader_idType_User='STRING'
ENV persistence_idGenerationMode_Role='ClientGeneratedOnly'
ENV persistence_idGenerationMode_User='ClientGeneratedOnly'
USER tomcat
