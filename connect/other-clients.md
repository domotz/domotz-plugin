# Other MCP clients

Any assistant that can connect to a remote MCP server works:

- **Server:** `https://mcp.domotz.com/mcp` (Streamable HTTP)
- **Auth:** OAuth sign-in with your Domotz account, or an MCP API key sent as
  `Authorization: Bearer <key>` (create one in the Domotz webapp under
  **Account → Domotz MCP API**).

**Clients with Agent Skills support:** copy the playbook folder into the client's skills
directory (see its documentation for the location).

**Clients without skills:** paste the playbook's `SKILL.md` as the first message of the
conversation, or into the client's custom instructions if it fits.

Tip: the Domotz server exposes many tools. If your client lets you choose, enable the read
tools and only the write tools a playbook needs.
