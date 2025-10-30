# Managing google cloud resources

They are managed using opentofu.

It may be necessary to generate the configuration for them and import them as shown in [importing-resources-into-opentofu.md].

It may also be necessary for very complex JSON objects to store as a simple `.json` fild rather than inline in the `.tf`.

The format of these objects; and partocularly how they handle defaults can drift overtime.
In this case to prevent perpetual diffs it may be necessary to update the json but downloading it from the google api. e.g. https://cloud.google.com/monitoring/api/ref_v3/rest/v1/projects.dashboards/get for dashboards.