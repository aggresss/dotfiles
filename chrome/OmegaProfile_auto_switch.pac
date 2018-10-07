var FindProxyForURL = function(init, profiles) {
    return function(url, host) {
        "use strict";
        var result = init, scheme = url.substr(0, url.indexOf(":"));
        do {
            result = profiles[result];
            if (typeof result === "function") result = result(url, host, scheme);
        } while (typeof result !== "string" || result.charCodeAt(0) === 43);
        return result;
    };
}("+auto switch", {
    "+auto switch": function(url, host, scheme) {
        "use strict";
        if (/(?:^|\.)twitter\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)twimg\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)google\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)python\.org$/.test(host)) return "+proxy";
        if (/(?:^|\.)youtube\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)golang\.org$/.test(host)) return "+proxy";
        if (/(?:^|\.)avatars0\.githubusercontent\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)github\.com$/.test(host)) return "+proxy";
        if (/(?:^|\.)google\.co\.jp$/.test(host)) return "+proxy";
        if (/(?:^|\.)googleusercontent\.com$/.test(host)) return "+proxy";
        return "DIRECT";
    },
    "+proxy": function(url, host, scheme) {
        "use strict";
        if (/^127\.0\.0\.1$/.test(host) || /^::1$/.test(host) || /^localhost$/.test(host)) return "DIRECT";
        return "SOCKS5 127.0.0.1:1080; SOCKS 127.0.0.1:1080";
    }
});
