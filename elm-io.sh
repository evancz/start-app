#!/usr/bin/env bash
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <generated-js-file> <output-file>"
    exit 1
fi

read -d '' before <<- EOF
var jsdom = require("jsdom");
var callback = function(errors, window) {
  var document = window.document;
// Elm goes here:
EOF

read -d '' handler <<- EOF
// Elm goes there ^
(function(){
    var stdin = process.stdin;
    var fs    = require('fs');
    var worker = Elm.worker(Elm.Main
                            , {responses: null }
                           );
    var just = function(v) {
        return { 'Just': v};
    }
    var handle = function(request) {
        // Debugging:
        // console.log("Bleh: %j", request);
        switch(request.ctor) {
        case 'Put':
            process.stdout.write(request.val);
            break;
        case 'Get':
            stdin.resume();
            break;
        case 'Exit':
            process.exit(request.val);
            break;
        case 'WriteFile':
            fs.writeFileSync(request.file, request.content);
            break;
        }
    }
    var handler = function(reqs) {
        for (var i = 0; i < reqs.length; i++) {
            handle(reqs[i]);
        }
        if (reqs.length > 0 && reqs[reqs.length - 1].ctor !== 'Get') {
            worker.ports.responses.send(just(""));
        }
    }
    worker.ports.requests.subscribe(handler);
    
    // Read
    stdin.on('data', function(chunk) {
        //console.log('Got' + chunk);
        stdin.pause();
        worker.ports.responses.send(just(chunk.toString()));
    })

    // Start msg
    worker.ports.responses.send(null);
})();
} // Close the callback
// Run!
jsdom.env('<p>bleh</p>', [], callback);
EOF

touch $2
echo "$before" > $2
cat $1 >> $2
echo "$handler" >> $2
