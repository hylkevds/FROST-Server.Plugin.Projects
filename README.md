# Fine-Grained Security with Projects

A fine-grained security definition for FROST-Server, based on Projects.

## Installing

This Plugin is now supplied with FROST-Server by default, see https://fraunhoferiosb.github.io/FROST-Server/settings/plugins.html#projects

The plugin can be used with docker, or directly on an existing Tomcat server.

### Docker

The easiest way to use the plugin is as a docker image.
An [example DockerCompse file](scripts/docker-compose.yaml) is provided with the plugin.
You can either build the Docker image yourself using the provided [Dockerfile](Dockerfile) or use the image `hylkevds/frost-http-projects:latest`.

### Tomcat

To use the plugin with a FROST-Server installed directly in a local Tomcat:
1. Copy the files to the local file system (easiest using `git checkout `)
1. Add the following parameters to the context XML file:
   - `plugins.coreModel.enable` = `true`
   - `plugins.actuation.enable` = `false`
   - `plugins.multiDatastream.enable` = `false`
   - `plugins.openApi.enable` = `true`
   - `plugins.odata.enable` = `true`
   - `plugins.csv.enable` = `true`
   - `plugins.geojson.enable` = `true`
   - `plugins.modelLoader.enable` = `true`
   - `plugins.modelLoader.modelPath` = `/usr/local/tomcat/webapps/FROST-Server/WEB-INF/data/model`
   - `plugins.modelLoader.modelFiles` = `Project.json, Restricted.json, Role.json, User.json, UserProjectRole.json`
   - `plugins.modelLoader.securityPath` = `/usr/local/tomcat/webapps/FROST-Server/WEB-INF/data/security`
   - `plugins.modelLoader.securityFiles` = `secDatastream.json, secFeature.json, secHistoricalLocation.json, secLocation.json, secObservation.json, secProject.json, secRole.json, secSensor.json, secThing.json, secUser.json, secUserProjectRole.json`
   - `plugins.modelLoader.liquibasePath` = `/usr/local/tomcat/webapps/FROST-Server/WEB-INF/data/liquibase`
   - `plugins.modelLoader.liquibaseFiles` = `tablesSecurityUPR.xml`
   - `plugins.modelLoader.idType.Role` = `STRING`
   - `plugins.modelLoader.idType.User` = `STRING`
   - `persistence.idGenerationMode.Role` = `ClientGeneratedOnly`
   - `persistence.idGenerationMode.User` = `ClientGeneratedOnly`
1. Correct the three paths to the modelFiles, securityFiles and liquibaseFiles.
1. Restart the web application and run the database update.


## Users, Projects, Roles, UserProjectRoles

**Users** are actors that can log in. Users are stored in the `USERS` table. Test users are:
- read
- write
- admin

The `Users` entity type is visible to all users, but normal users can only see their own User entry.
Only global-admin users and project-admin users can see all users.
Password are not visible to anyone, not even to admin users.

Users can change their own password.

**Roles** embody sets of permissions that a user can have. Roles are stored in the `ROLES` table. Test roles are:

- read
- create
- obscreate
- update
- delete
- admin

The `Roles` entity type is only visible to admin users.

Users can have global Roles. The global roles are stored in the `USER_ROLES` table that directly links Users to Roles.

- A global admin user is allowed to do everything.
- A user with a global "create" role is allowed to create all entity types except for Users and admin-only types (Roles, UserProjectRoles).
- A user with a global "read" role can read all entities, except for other User entities or admin-only types.

**Projects** are administrative entities grouping data (through Things).
Projects are stored in the `PROJECTS` table.
Projects can be public or private.
Public projects, and their associated Things, Datastreams, etc., can be read by everyone.
Private projects, and their associated Things, Datastreams, etc., can only be read by users associated to the project.

Users can have project-roles. Users are linked to a Project with a certain Role through the `USER_PROJECT_ROLE` table.

**UserProjectRoles** Link a User with a specific Role to a Project. A User can have multiple Roles in the same Project.

The `UserProjectRoles` entity type is only visible to admin users.

Users without a global "read" role, but with a project-related "read" role can only read Observations that have a Datastream that has a Thing that is linked to a Project that the user is in.

**Things**, **Locations**, **Datastreams** and **FeaturesOfInterest** can be restricted.
This means that even if they are associated with a public project, they can still only be read by users associated to that project.
When not explicitly specified, these Entities will *not* be restircted by default.

**Locations** and **FeaturesOfInterest** have their normally hidden link exposed, that indicates that a FeatureOfInterest is autogenerated for a specific Location.
This means that, when creating a Location, the FeatureOfInterest that will be used for Obserations that do not specify one, can directly be created as well.

## Data Model

The image below shows the core STA data model in blue, with the security extension in yellow.

![Data Model](Datamodel-SensorThingsApi-Projects.drawio.png)

