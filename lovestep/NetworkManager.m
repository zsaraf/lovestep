//
//  NetworkManager.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/13/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()

@property (nonatomic, strong) NSNetService *netService;
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSArray *connectedSockets;
@property (nonatomic, strong) NSNetServiceBrowser *netServiceBrowser;
@property (nonatomic, strong) NSNetService *serverService;
@property (nonatomic, assign) BOOL didFindNetwork;

@end

@implementation NetworkManager

static NetworkManager *myInstance;

//singleton
+(NetworkManager *)instance
{
    @synchronized(self)
    {
        if (myInstance == NULL)
            myInstance = [[self alloc] init];
    }
    
    return(myInstance);
}

-(void)publishNetwork
{
    // Create our socket.
	// We tell it to invoke our delegate methods on the main thread.
	
	self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	// Create an array to hold accepted incoming connections.
	
    self.connectedSockets = [[NSMutableArray alloc] init];
	
	// Now we tell the socket to accept incoming connections.
	// We don't care what port it listens on, so we pass zero for the port number.
	// This allows the operating system to automatically assign us an available port.
	
	NSError *err = nil;
	if ([self.asyncSocket acceptOnPort:0 error:&err])
	{
		// So what port did the OS give us?
		
		UInt16 port = [self.asyncSocket localPort];
		
		// Create and publish the bonjour service.
		// Obviously you will be using your own custom service type.
		
		self.netService = [[NSNetService alloc] initWithDomain:@""
		                                             type:@"_lovestep._tcp."
		                                             name:@""
		                                             port:port];
		
		[self.netService setDelegate:self];
		[self.netService publish];
	}
	else
	{
        NSLog(@"were royally fucked");
	}
}

-(void)searchForNetwork
{
    self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
	
	[self.netServiceBrowser setDelegate:self];
	[self.netServiceBrowser searchForServicesOfType:@"_lovestep._tcp." inDomain:@""];
    [self.netServiceBrowser scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:@"Cool"];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didTimeOut:) userInfo:Nil repeats:NO];
}

-(IBAction)didTimeOut:(NSTimer *)sender
{
    [self.netServiceBrowser stop];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
           didFindService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
    NSLog(@"method is called");
	// Connect to the first service we find
	if (self.serverService == nil)
	{
        NSLog(@"FOUND SERVICE %@", netService);
        self.didFindNetwork = YES;
		self.serverService = netService;
		
		[self.serverService setDelegate:self];
		[self.serverService resolveWithTimeout:3.0];
        [sender stop];
	}
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
    NSLog(@"huh?");
    NSLog(@"%@", domainString);
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
    NSLog(@"did remove domain");
}

-(void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    [self.delegate networkManagerDidFindNetworkService:self.didFindNetwork];
    NSLog(@"did stop search, found a published network %@", self.didFindNetwork ? @"YES" : @"NO");
}

-(void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    NSLog(@"will begin searching");
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
    NSLog(@"didnotsearch");
}

-(void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"were so fucked");
}

-(void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"were heroes");
}

-(void)netServiceWillPublish:(NSNetService *)sender
{
    NSLog(@"%@ %@ %@", sender, self.netService, self.serverService);
    NSLog(@"will publish");
}

-(void)netServiceDidResolveAddress:(NSNetService *)sender
{
    if (sender == self.serverService) {
        NSLog(@"resolved in serverservice");
    } else if (sender == self.netService) {
        NSLog(@"resolved in netservice");
    }
}

-(void)netServiceDidStop:(NSNetService *)sender
{
    
}

-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"%@", errorDict);
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"did receive data %@", data);
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"did connect to host %@", host);
}

@end
