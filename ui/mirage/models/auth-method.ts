import { Model } from 'miragejs';
import { OIDCAuthMethod } from 'derrick-pb';

export default Model.extend({
  toProtobuf(): OIDCAuthMethod {
    let result = new OIDCAuthMethod();

    result.setDisplayName(this.displayName);
    result.setKind(this.kind);
    result.setName(this.name);
    return result;
  },
});
