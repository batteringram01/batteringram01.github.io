---
layout: post
title: "OpenNebula API in Go"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---


For those who don't know what [OpenNebula](http://opennebula.org/) is, It is a simple, resilient hybrid cloud platform that is very easy to get started. Yes, one(short for OpenNebula) is less complicated and can be set up in few hours. Oh wait, now the most obvious question pops up! so how good is it when compared to OpenStack? Let me try and give a quick answer, OpenStack is a toolkit for building complex IaaS, it has multiple blocks of differnet tools on different layers combined, so with OpenStack you have the ability to tune each block for each need, but in OpenNebula, it is all combined, which makes it a lot easier to get started. I am going to stick to the topic and write about how I wrote an API in golang that talks to OpenNebula to create and control virtual machines. This is the only golang OpenNebula API that is available on github at the time of writing.
<!--more-->

**Note: This article assumes that you have golang and opennebula already installed**

### Existing One Clients

OpenNebula currently support two interfaces, one is the XMLRPC interface and other one is cloud API which supports Ruby and Java.
If you have worked on integrating OpenNebula or any cloud platform into your web services, you would have come across the [fog](https://github.com/fog/fog) project. A kickass ruby library to talk to almost every cloud service that is out there. Really, thanks to [fog.io](http://fog.io) folks.


The One gem actually talks to the OpenNebula Ruby Client([here](https://github.com/OpenNebula/one/tree/master/src/oca/ruby/opennebula)) to make the RPC calls to the One RPC server. Some code from the OCA ruby api below

```ruby

        # Initiates the instance of the VM on the target host.
        #
        # @param host_id [Interger] The host id (hid) of the target host where
        #   the VM will be instantiated.
        # @param enforce [true|false] If it is set to true, the host capacity
        #   will be checked, and the deployment will fail if the host is
        #   overcommited. Defaults to false
        # @param ds_id [Integer] The System Datastore where to deploy the VM. To
        #   use the default, set it to -1
        #
        # @return [nil, OpenNebula::Error] nil in case of success, Error
        #   otherwise
        def deploy(host_id, enforce=false, ds_id=-1)
            enforce ||= false
            ds_id ||= -1
            return call(VM_METHODS[:deploy],
                        @pe_id,
                        host_id.to_i,
                        enforce,
                        ds_id.to_i)
        end

```
### Design and structure

The [opennebula-go](https://github.com/megamsys/opennebula-go) api uses XMLRPC interface to manage the VMs.Please note that this project is still under development and I wrote the API to suit our needs at megam and still tried to keep a generic design so anyone can use it. At [megam](https://www.megam.io), we were moving away from Chef's knife CLI tool to direct OpenNebula RPC calls from our PaaS engine to increase performance. If I find time, I will finish the API fully.


* api - RPC Client
* compute - VM control
* templates - Manipulating templates
* VirtualMachines - Manipulating VMs


### RPC API


RPC api returns an rpc client object, It is passed around in every individual api to make RPC calls to the One server.
I used this go [xmlrpc](https://github.com/kolo/xmlrpc) library.

```go

/**
 *
 * Creates an RPCClient  returns it
 *
 **/
func NewRPCClient(endpoint string, username string, password string) (Rpc, error) {
	RPCclient, err := xmlrpc.NewClient(endpoint, nil)
	if err != nil {
		log.Fatal(err)
	}
	RpcObj := Rpc{RPCClient: *RPCclient, Key: username + ":" + password}
	fmt.Println(RpcObj.Key)
	return RpcObj, nil
}
```

### Compute & Template API

The compute API is used to create and delete the Virtual Machines. With the given template name and an rpc client created with the correct credentials, this will instantiate a VM or delete it.

This uses `one.template.instantiate` and `one.vm.action` xml-rpc methods

Template API currently has `GetTemplate()` , `GetTemplateByName()` and `UpdateTemplate()` functions to retrieve templates and update them if necessary.

```go
func (t *TemplateReqs) GetTemplateByName() ([]*UserTemplate, error) {
	args := []interface{}{t.Client.Key, -2, -1, -1}
	templatePool, _ := t.Client.Call(t.Client.RPCClient, TEMPLATEPOOL_INFO, args)

	xmlStrt := UserTemplates{}
	assert := templatePool[1].(string)
	_ = xml.Unmarshal([]byte(assert), &xmlStrt)

	var matchedTemplate = make([]*UserTemplate, len(xmlStrt.UserTemplate))

	for _, v := range xmlStrt.UserTemplate {
		if v.Name == t.TemplateName {
			matchedTemplate[0] = v
		}
	}
	return matchedTemplate, nil
}
```

The above code will make an RPC call to get the template with TemplateReqs struct object containing the rpc client and template name.
An RPC call with the correct args returns `templatePool` which contains all templates for that particular host, it is then parsed using go's xml ,matched using the give name and returned


##Using the API

Using the api is dead simple, creating a VM will hardly take few lines of code.
Remember, the RPC endpoint for One is `http://<ip>:2633/RPC2`

**Note**: if you want to find your username:pass, run this command as super user

    $cat /var/lib/one/.one/one_auth

```go

//create a client
client, _ := api.NewRPCClient("http://localhost:2633/RPC2", "oneadmin", "password")
//Give your vm specs, mainly templatename and client
vmObj := VirtualMachine{Name: "yeshapp", TemplateName: "fullfledged", Cpu: "1", VCpu: "1", Memory: "4500", Client: &client}
//call the create api
_, error := vmObj.Create()
```

Thats it! Open up your sunstone UI to see the VM firing up. The API is still young and contributions are welcome. Thats it for now.
