import { Factory, trait, association } from 'ember-cli-mirage';

export default Factory.extend({
  'derrick-ssh': trait({
    url: 'git@github.com:nomatronio/derrick.git',
    ref: 'main',
    path: 'website',
    ssh: association('example'),
  }),
});
