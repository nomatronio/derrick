import { Model, belongsTo } from 'miragejs';
import { StatusReport } from 'derrick-pb';

export default Model.extend({
  statusReport: belongsTo({ inverse: 'health' }),
  statusReportList: belongsTo('status-report', { inverse: 'resourcesHealthList' }),

  toProtobuf(): StatusReport.Health {
    let result = new StatusReport.Health();

    result.setHealthStatus(this.status);
    result.setHealthMessage(this.message);

    return result;
  },
});
