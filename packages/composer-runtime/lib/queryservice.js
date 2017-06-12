/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

/**
 * Base class representing the http service provided by a {@link Container}.
 * @protected
 * @abstract
 * @memberof module:composer-runtime
 */
class QueryService {

    /**
     * Constructor.
     */
    constructor() {
    }

    /**
     * HTTP POST of a typed instance to a URL. The instance is serialized to JSON
     * and the JSON text is in the body of the HTTP POST.
     * @param {string} queryString - the couchdb query string
     * @return {Promise} A promise that will be resolved with a {@link HttpResponse}
     */
    queryNative(queryString) {
        return new Promise((resolve, reject) => {
            this._queryNative(queryString, (error, result) => {
                if (error) {
                    return reject(error);
                }
                return resolve(result);
            });
        });
    }

    /**
     * Execute CouchDB queryString
     * @abstract
     * @param {string} queryString - the couchdb query string
     * @param {callback} callback The callback function to call when complete.
     */
    _queryNative(queryString, callback) {
        throw new Error('abstract function called');
    }

    /**
     * Stop serialization of this object.
     * @return {Object} An empty object.
     */
    toJSON() {
        return {};
    }
}

module.exports = QueryService;