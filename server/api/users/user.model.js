'use strict';
const debug = require('debug')('mongo:schemas');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const bcrypt = require('bcryptjs');

const UserSchema = new Schema({
    name: {
        type: String,
        required: true,
        validate: {
            validator: (v) => {
                return v.length > 2;
            },
            message: p => `${p.value} is not valid`
        }
    },
    surname: {
        type: String,
        required: true,
        validate: {
            validator: (v) => {
                return v.length > 2;
            },
            message: p => `${p.value} is not valid`
        }
    },
    avatar:{
        type:mongoose.Types.ObjectId
    },
    pesel: {
        type: String,
        required: true,
        validate: {
            validator: (v) => {
                return /([0-9]{11})/g.test(v) && v.length == 11;
            },
            message: p => `${p.value} is not valid`
        }
    },
    IDCardNumber: {
        type: String,
        required: true,
    },
    desc: {
        type: String,
    },
    email: {
        type: String,
        required: true,
    },
    age: {
        type: Number,
        required: true,
    },
    votes:{
        type: Number,
        default:0,
    },
    voteNumber:{
        type: Number,
    },
    candidate:{
        type:Boolean,
        default:false
    },
    gaveVote:{
        type:Boolean,
        default:false,
    },
    permissions: {
        type: String,
        default: 0,
    },
    password: {
        type: String,
        required: true,
    },
    salt: {
        type: String,
    }
}, {
    toJSON: {
        virtuals: true,
        transform: function (doc, ret) {
            ret = ret.public;
            return ret;
        }
    }
});
//virtuals
UserSchema.virtual('public').get(function () {
    return {
        _id: this._id,
        name: this.name,
        surname: this.surname,
        email: this.email,
        candidate: this.candidate,
        votes: this.votes,
        gaveVote: this.gaveVote,
        pesel: this.pesel,
        desc: this.desc,
        age: this.age,
        avatar:this.avatar
    };
});
UserSchema.virtual('profile').get(function () {
    return {
        _id: this._id,
        name: this.name,
        surname: this.surname,
        email: this.email,
        candidate: this.candidate,
        votes: this.votes,
        gaveVote: this.gaveVote,
        pesel: this.pesel,
        desc: this.desc,
        age: this.age,
        avatar:this.avatar
    };
});
/**
 * Validations
 */

// Validate empty password
UserSchema.path('password').validate(function (password) {
    return password.length;
}, 'Password cannot be blank');

// // Validate email is not taken
UserSchema.path('pesel').validate(async function (value) {
    const self = this;

    return await this.constructor
        .findOne({
            pesel: value
        })
        .then(function (user) {
            if (user) {
                if (self.id === user.id) {
                    return false;
                }
                return false;
            }
            return true;
        })
        .catch(function (err) {
            debug(err);
            throw err;
        });
}, 'The specified Pesel is already in use.');

UserSchema.path('email').validate(async function (value) {
    const self = this;

    return await this.constructor
        .findOne({
            email: value
        })
        .then(function (user) {
            if (user) {
                if (self.id === user.id) {
                    return false;
                }
                return false;
            }
            return true;
        })
        .catch(function (err) {
            debug(err);
            throw err;
        });
}, 'The specified email is already in use.');
var validatePresenceOf = function (value) {
    return value && value.length;
};

/**
 * Pre-save hook
 */
UserSchema.pre('save', function (next) {
    // Handle new passwords
    if (this.isModified('password')) {
        if (!validatePresenceOf(this.password)) {
            next(new Error('Invalid password'));
        }

        // Make salt with a callback
        const _this = this;
        this.makeSalt(function (saltErr, salt) {
            if (saltErr) {
                next(saltErr);
            }
            _this.salt = salt;

            _this.encryptPassword(_this.password, function (
                encryptErr,
                hashedPassword
            ) {
                if (encryptErr) {
                    next(encryptErr);
                }
                _this.password = hashedPassword;
                next();
            });
        });
    } else {
        next();
    }
});

/**
 * Methods
 */
UserSchema.methods = {
    /**
     * Authenticate - check if the passwords are the same
     *
     * @param {String} password
     * @param {Function} callback
     * @return {Boolean}
     * @api public
     */
    authenticate: function (password, callback) {
        if (!callback) {
            return this.password === this.encryptPassword(password);
        }

        const _this = this;
        this.encryptPassword(password, function (err, pwdGen) {

            if (err) {
                callback(err);
            }

            if (_this.password === pwdGen) {
                callback(null, true);
            } else {
                callback(null, false);
            }
        });
    },

    /**
     * Make salt
     *
     * @param {Number} byteSize
     * @param {Function} callback
     * @return {String}
     * @api public
     */
    makeSalt: function (byteSize, callback) {
        const defaultByteSize = 10;

        if (typeof arguments[0] === 'function') {
            callback = arguments[0];
            byteSize = defaultByteSize;
        } else if (typeof arguments[1] === 'function') {
            callback = arguments[1];
        }
        if (!callback) {
            return bcrypt.genSalt(byteSize);
        }

        return bcrypt.genSalt(byteSize, (err, salt) => {
            if (err) callback(err);
            return callback(null, salt);
        });
    },
    /**
     * Encrypt password
     *
     * @param {String} password
     * @param {Function} callback
     * @return {String}
     * @api public
     */
    encryptPassword: function (password, callback) {
        if (!password || !this.salt) {
            return null;
        }

        if (!callback) {
            bcrypt.hash(password, this.salt);
        }

        return bcrypt.hash(password, this.salt, (err, hash) => {
            if (err) callback(err);
            return callback(null, hash);
        });
    }
};

module.exports = mongoose.model('Users', UserSchema, 'Users');