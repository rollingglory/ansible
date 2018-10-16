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

class FilterModule(object):
    def filters(self):
        return {
            'env': env,
        }