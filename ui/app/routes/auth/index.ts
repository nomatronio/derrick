import ApiService from 'derrick/services/api';
import { Empty } from 'google-protobuf/google/protobuf/empty_pb';
import { ListOIDCAuthMethodsResponse } from 'derrick-pb';
import Route from '@ember/routing/route';
import SessionService from 'ember-simple-auth/services/session';
import { inject as service } from '@ember/service';

export default class AuthIndex extends Route {
  @service session!: SessionService;
  @service api!: ApiService;

  async model(): Promise<ListOIDCAuthMethodsResponse.AsObject | undefined> {
    let authMethods = await this.api.client.listOIDCAuthMethods(new Empty(), this.api.WithMeta());
    if (authMethods.getAuthMethodsList().length) {
      let providers = authMethods.toObject();
      return providers;
    } else {
      return;
    }
  }
}
