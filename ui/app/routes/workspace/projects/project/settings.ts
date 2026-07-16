import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import ApiService from 'derrick/services/api';
import { Ref, GetProjectRequest, Project } from 'derrick-pb';
import { Breadcrumb } from 'derrick/services/breadcrumbs';
import { Params as ProjectRouteParams } from 'derrick/routes/workspace/projects/project';

type Model = Project.AsObject;

export default class WorkspaceProjectsProjectSettings extends Route {
  @service api!: ApiService;

  breadcrumbs(model: Model): Breadcrumb[] {
    if (!model) return [];
    return [
      {
        label: model.name,
        route: 'workspace.projects.project.index',
      },
      {
        label: 'Settings',
        route: 'workspace.projects.project.settings',
      },
    ];
  }

  async model(): Promise<Model> {
    // Setup the project request
    let ref = new Ref.Project();
    let params = this.paramsFor('workspace.projects.project') as ProjectRouteParams;
    ref.setProject(params.project_id);
    let req = new GetProjectRequest();
    req.setProject(ref);

    let resp = await this.api.client.getProject(req, this.api.WithMeta());
    let project = resp.getProject();

    if (!project) {
      // In reality the API will return an error in this circumstance
      // but the types don’t tell us that.
      throw new Error(`Project ${params.project_id} not found`);
    }

    return project.toObject();
  }
}
