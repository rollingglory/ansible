def env(s, lkey = '', uppercase = False):
    ret = {}
    for rkey, val in s.items():
        key = lkey + rkey
        if (uppercase):
          key = key.upper()

        if isinstance(val, dict):
            ret.update(env(val, key+'_', uppercase))
        else:
            ret[key] = val
    return ret

print(env({'fathom': {'server_addr': 9000, 'database': {'driver': 'sqlite3', 'name': 'fathom.db'}, 'secret': 'random-secret-string'}}))

class FilterModule(object):
    def filters(self):
        return {
            'env': env,
        }