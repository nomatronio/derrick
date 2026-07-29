import Component from '@glimmer/component';
import RouterService from '@ember/routing/router-service';
import SessionService from 'ember-simple-auth/services/session';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';

export default class Logout extends Component {
  @service session!: SessionService;
  @service router!: RouterService;

  @action
  async logout(): Promise<void> {
    this.session.set('data.workspace', undefined);
    await this.session.invalidate();
    this.router.transitionTo('auth');
  }
}
