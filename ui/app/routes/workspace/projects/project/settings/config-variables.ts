import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import ApiService from 'derrick/services/api';
import { Breadcrumb } from 'derrick/services/breadcrumbs';
import { ConfigGetRequest, ConfigGetResponse, Ref } from 'derrick-pb';
import {
  Model as ProjectRouteModel,
  Params as ProjectRouteParams,
} from 'derrick/routes/workspace/projects/project';
import ConfigVariablesController from 'derrick/controllers/workspace/projects/project/settings/config-variables';

export default class WorkspaceProjectsProjectSettingsConfigVariables extends Route {
  @service api!: ApiService;

  breadcrumbs(): Breadcrumb[] {
    return [
      {
        label: 'Config Variables',
        route: 'workspace.projects.project.settings.config-variables',
      },
    ];
  }

  async model(): Promise<ConfigGetResponse.AsObject> {
    let ref = new Ref.Project();
    let params = this.paramsFor('workspace.projects.project') as ProjectRouteParams;
    ref.setProject(params.project_id);
    let req = new ConfigGetRequest();
    req.setProject(ref);

    let config = await this.api.client.getConfig(req, this.api.WithMeta());
    return config?.toObject();
  }

  setupController(...args: Parameters<Route['setupController']>): void {
    super.setupController(...args);

    let controller = args[0] as ConfigVariablesController;
    let project = this.modelFor('workspace.projects.project') as ProjectRouteModel;

    controller.project = project;
  }
}
