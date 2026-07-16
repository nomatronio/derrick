import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import ApiService from 'derrick/services/api';
import { StatusReport } from 'derrick-pb';
import { findImageRefs } from 'derrick/utils/image-refs';

interface Args {
  statusReport: StatusReport.AsObject;
}

export default class extends Component<Args> {
  @service api!: ApiService;

  get states(): unknown {
    return this.args.statusReport.resourcesList
      ? this.args.statusReport.resourcesList.map(stateFromResource)
      : [];
  }

  get imageRefs(): ReturnType<typeof findImageRefs> {
    return findImageRefs(this.states);
  }
}

function stateFromResource(resource: StatusReport.Resource.AsObject): unknown {
  try {
    return JSON.parse(resource.stateJson);
  } catch (error) {
    console.error('Could not parse stateJson for resource', resource);
    return {};
  }
}
