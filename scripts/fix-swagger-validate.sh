#!/usr/bin/env bash
# fix-swagger-validate.sh — fix go-swagger Validate naming collisions for Job types.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODELS="$ROOT/pkg/client/gen/models"

fix_method() {
  local f="$1"
  perl -i -pe 's/^func \(m \*([^)]+)\) Validate\(formats strfmt\.Registry\)/func (m *$1) SwaggerValidate(formats strfmt.Registry)/' "$f"
  perl -i -pe 's/^\/\/ Validate validates/\/\/ SwaggerValidate validates/' "$f"
}

fix_method "$MODELS/nomatron_derrick_job.go"
fix_method "$MODELS/nomatron_derrick_job_result.go"

replace_validate() {
  local file="$1"
  local expr="$2"
  perl -i -pe "$expr" "$MODELS/$file"
}

# *NomatronDerrickJob pointer fields
for file in \
  nomatron_derrick_validate_job_request.go \
  nomatron_derrick_queue_job_request.go \
  nomatron_derrick_runner_job_stream_response_job_assignment.go \
  nomatron_derrick_get_job_stream_response_job_change.go \
  nomatron_derrick_get_job_stream_response_state.go \
  nomatron_derrick_get_task_response.go \
  nomatron_derrick_run_pipeline_request.go \
  nomatron_derrick_job_queue_project_op.go \
  nomatron_derrick_ui_get_project_response.go
do
  replace_validate "$file" '
    s/m\.Job\.Validate\(/m.Job.SwaggerValidate(/g;
    s/m\.StartJob\.Validate\(/m.StartJob.SwaggerValidate(/g;
    s/m\.StopJob\.Validate\(/m.StopJob.SwaggerValidate(/g;
    s/m\.TaskJob\.Validate\(/m.TaskJob.SwaggerValidate(/g;
    s/m\.WatchJob\.Validate\(/m.WatchJob.SwaggerValidate(/g;
    s/m\.JobTemplate\.Validate\(/m.JobTemplate.SwaggerValidate(/g;
    s/m\.LatestInitJob\.Validate\(/m.LatestInitJob.SwaggerValidate(/g;
  '
done

# Job slices
replace_validate "nomatron_derrick_list_jobs_response.go" 's/m\.Jobs\[i\]\.Validate\(/m.Jobs[i].SwaggerValidate(/g'

# *NomatronDerrickJobResult pointer fields
for file in \
  nomatron_derrick_job.go \
  nomatron_derrick_get_job_stream_response_complete.go \
  nomatron_derrick_runner_job_stream_request_complete.go
do
  replace_validate "$file" 's/m\.Result\.Validate\(/m.Result.SwaggerValidate(/g'
done

echo "swagger validate collision fix complete"
