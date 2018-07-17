// Objection Docs:
// http://vincit.github.io/objection.js/

'use strict';

const db    = require('../db');
const Model = require('objection').Model;
const User  = require('./user');

Model.knex(db);

class AccessList extends Model {
    $beforeInsert () {
        this.created_on  = Model.raw('NOW()');
        this.modified_on = Model.raw('NOW()');
    }

    $beforeUpdate () {
        this.modified_on = Model.raw('NOW()');
    }

    static get name () {
        return 'AccessList';
    }

    static get tableName () {
        return 'access_list';
    }

    static get jsonAttributes () {
        return ['meta'];
    }

    static get relationMappings () {
        return {
            owner: {
                relation:   Model.HasOneRelation,
                modelClass: User,
                join:       {
                    from: 'access_list.owner_user_id',
                    to:   'user.id'
                },
                modify:     function (qb) {
                    qb.where('user.is_deleted', 0);
                    qb.omit(['id', 'created_on', 'modified_on', 'is_deleted', 'email', 'roles']);
                }
            }
        };
    }
}

module.exports = AccessList;
