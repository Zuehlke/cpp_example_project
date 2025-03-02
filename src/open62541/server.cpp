#include <open62541/server.h>
#include <open62541/server_config_default.h>

// This example is the original one from the open62541 examples

int main()
{
    UA_Server *server = UA_Server_new();
    UA_Server_run_startup(server);

    /* Should the server networklayer block (with a timeout) until a message
       arrives or should it return immediately? */
    const UA_Boolean waitInternal = true;
    while (true) { UA_Server_run_iterate(server, waitInternal); }

    UA_Server_run_shutdown(server);
    UA_Server_delete(server);
    return 0;
}
