#!/bin/bash
# Lab program generator
# Shows a menu; after you pick a program it creates the "externals" folder
# (if missing) and writes the chosen program's code into a file there.

DIR="externals"

make_dir() {
    mkdir -p "$DIR"
}

done_msg() {
    echo "Created: $DIR/$1"
}

# ---------------------------------------------------------------- PART A

a1() {
    make_dir
    cat > "$DIR/a1_dijkstra.cpp" <<'__CODE_END__'
#include <iostream>
using namespace std;
const int INF = 99;
int main() {
 int n, cost[10][10], dist[10], parent[10];
 bool visited[10] = {false};
 cout << "Enter the number of vertices (6-10): ";
 cin >> n;
 if (n < 6 || n > 10) {
 cout << "Invalid number of vertices.\n";
 return 1;
 }
 cout << "Enter the cost adjacency matrix (99 for no edge):\n";
 for (int i = 0; i < n; i++)
 for (int j = 0; j < n; j++)
 cin >> cost[i][j];
 int src;
 cout << "Enter the source vertex (0 to " << n - 1 << "): ";
 cin >> src;
 if (src < 0 || src >= n) {
 cout << "Invalid source vertex.\n";
 return 1;
 }
 for (int i = 0; i < n; i++) {
 dist[i] = INF;
 parent[i] = -1;
 }
 dist[src] = 0;
 for (int i = 0; i < n; i++) {
 int u = -1;
 for (int j = 0; j < n; j++)
 if (!visited[j] && (u == -1 || dist[j] < dist[u]))
 u = j;
 if (u == -1 || dist[u] == INF)
 break;
 visited[u] = true;
 for (int v = 0; v < n; v++) {
 if (!visited[v] && cost[u][v] < INF &&
 dist[u] + cost[u][v] < dist[v]) {
 dist[v] = dist[u] + cost[u][v];
 parent[v] = u;
 }
 }
 }
 for (int v = 0; v < n; v++) {
 if (v == src)
 continue;
 cout << "\nShortest path from " << src << " to " << v << ":\n";
 if (dist[v] == INF) {
 cout << "No path exists.\n";
 continue;
 }
 int path[10], len = 0;
 for (int u = v; u != -1; u = parent[u])
 path[len++] = u;
 for (int i = len - 1; i >= 0; i--) {
 cout << path[i];
 if (i > 0)
 cout << " -> ";
 }
 cout << "\nDistance = " << dist[v] << "\n";
 }
 return 0;
}
__CODE_END__
    done_msg "a1_dijkstra.cpp   (compile: g++ a1_dijkstra.cpp -o a1)"
}

a2() {
    make_dir
    cat > "$DIR/a2_crc.c" <<'__CODE_END__'
#include <stdio.h>
#include <string.h>
#define POLY "10001000000100001"
void calculateCRC(char bits[], char remainder[]) {
 char temp[200];
 int len = strlen(bits);
 strcpy(temp, bits);
 for (int i = 0; i <= len - 17; i++) {
 if (temp[i] == '1') {
 for (int j = 0; j < 17; j++)
 temp[i + j] = (temp[i + j] == POLY[j]) ? '0' : '1';
 }
 }
 strncpy(remainder, temp + len - 16, 16);
 remainder[16] = '\0';
}
int main() {
 char data[100], padded[200], crc[17];
 char frame[200], receivedCRC[17];
 printf("Enter the data to be sent: ");
 scanf("%99s", data);
 strcpy(padded, data);
 strcat(padded, "0000000000000000");
 calculateCRC(padded, crc);
 strcpy(frame, data);
 strcat(frame, crc);
 printf("\nCRC: %s\n", crc);
 printf("Transmitted frame: %s\n", frame);
 printf("\nEnter the received frame: ");
 scanf("%199s", frame);
 calculateCRC(frame, receivedCRC);
 printf("Receiver CRC: %s\n", receivedCRC);
 if (strcmp(receivedCRC, "0000000000000000") == 0)
 printf("Received frame is error-free.\n");
 else
 printf("Received frame has one or more errors.\n");
 return 0;
}
__CODE_END__
    done_msg "a2_crc.c   (compile: gcc a2_crc.c -o a2)"
}

a3() {
    make_dir
    cat > "$DIR/a3_distance_vector.c" <<'__CODE_END__'
#include <stdio.h>
#define MAX 10
#define INF 99
int cost[MAX][MAX], dist[MAX][MAX], next[MAX][MAX], n;
int main() {
 printf("Enter the number of vertices: ");
 scanf("%d", &n);
 if (n < 1 || n > MAX) {
 printf("Invalid number of vertices.\n");
 return 1;
 }
 printf("Enter the cost matrix (99 for no link):\n");
 for (int i = 0; i < n; i++) {
 for (int j = 0; j < n; j++) {
 scanf("%d", &cost[i][j]);
 dist[i][j] = cost[i][j];
 next[i][j] = j;
 }
 }
 for (int k = 0; k < n; k++) {
 for (int i = 0; i < n; i++) {
 for (int j = 0; j < n; j++) {
 if (dist[i][k] < INF && dist[k][j] < INF &&
 dist[i][j] > dist[i][k] + dist[k][j]) {
 dist[i][j] = dist[i][k] + dist[k][j];
 next[i][j] = next[i][k];
 }
 }
 }
 }
 for (int i = 0; i < n; i++) {
 printf("\nRouting table for router %c\n", 'A' + i);
 printf("Destination\tNext Hop\tDistance\n");
 for (int j = 0; j < n; j++) {
 if (dist[i][j] >= INF)
 printf("%c\t\t-\t\tInfinite\n", 'A' + j);
 else
 printf("%c\t\t%c\t\t%d\n",
 'A' + j, 'A' + next[i][j], dist[i][j]);
 }
 }
 return 0;
}
__CODE_END__
    done_msg "a3_distance_vector.c   (compile: gcc a3_distance_vector.c -o a3)"
}

a4() {
    make_dir
    cat > "$DIR/a4_tcp_server.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
void send_all(int sock, const char *buf, int len) {
 while (len > 0) {
 int n = send(sock, buf, len, 0);
 if (n <= 0) return;
 buf += n;
 len -= n;
 }
}
int main(int argc, char *argv[]) {
 int server, client, port;
 struct sockaddr_in addr;
 char filename[256], buffer[1024];
 if (argc != 2) {
 printf("Usage: %s <port>\n", argv[0]);
 return 1;
 }
 port = atoi(argv[1]);
 server = socket(AF_INET, SOCK_STREAM, 0);
 addr.sin_family = AF_INET;
 addr.sin_addr.s_addr = INADDR_ANY;
 addr.sin_port = htons(port);
 bind(server, (struct sockaddr *)&addr, sizeof(addr));
 listen(server, 5);
 printf("Server waiting for client...\n");
 client = accept(server, NULL, NULL);
 int n = recv(client, filename, sizeof(filename) - 1, 0);
 if (n <= 0) {
 close(client);
 close(server);
 return 1;
 }
 filename[n] = '\0';
 printf("Requested file: %s\n", filename);
 FILE *fp = fopen(filename, "r");
 if (fp == NULL) {
 send_all(client, "ERROR\n", 6);
 printf("File not found!\n");
 } else {
 send_all(client, "OK\n", 3);
 printf("File found! Sending contents...\n");
 while ((n = fread(buffer, 1, sizeof(buffer), fp)) > 0)
 send_all(client, buffer, n);
 fclose(fp);
 printf("File transfer completed.\n");
 }
 close(client);
 close(server);
 return 0;
}
__CODE_END__
    cat > "$DIR/a4_tcp_client.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
int main(int argc, char *argv[]) {
 int sock, port, n;
 struct sockaddr_in server;
 char filename[256], buffer[1024], status[7];
 int i = 0;
 if (argc != 3) {
 printf("Usage: %s <server-IP> <port>\n", argv[0]);
 return 1;
 }
 port = atoi(argv[2]);
 sock = socket(AF_INET, SOCK_STREAM, 0);
 server.sin_family = AF_INET;
 server.sin_port = htons(port);
 inet_pton(AF_INET, argv[1], &server.sin_addr);
 if (connect(sock, (struct sockaddr *)&server, sizeof(server)) < 0) {
 perror("Connection failed");
 close(sock);
 return 1;
 }
 printf("Enter filename: ");
 scanf("%255s", filename);
 send(sock, filename, strlen(filename), 0);
 while (i < 6 && recv(sock, &status[i], 1, 0) == 1) {
 if (status[i++] == '\n') break;
 }
 status[i] = '\0';
 if (strcmp(status, "OK\n") == 0) {
 printf("\nFile contents:\n");
 while ((n = recv(sock, buffer, sizeof(buffer), 0)) > 0)
 fwrite(buffer, 1, n, stdout);
 } else {
 printf("File not found on the server.\n");
 }
 close(sock);
 return 0;
}
__CODE_END__
    done_msg "a4_tcp_server.c and a4_tcp_client.c"
    echo "Compile: gcc a4_tcp_server.c -o server ; gcc a4_tcp_client.c -o client"
    echo "Run: ./server 8000   then   ./client 127.0.0.1 8000"
}

a5() {
    make_dir
    cat > "$DIR/a5_hamming.c" <<'__CODE_END__'
#include <stdio.h>
int h[12];
void generate() {
 h[1] = (h[3] + h[5] + h[7] + h[9] + h[11]) % 2;
 h[2] = (h[3] + h[6] + h[7] + h[10] + h[11]) % 2;
 h[4] = (h[5] + h[6] + h[7]) % 2;
 h[8] = (h[9] + h[10] + h[11]) % 2;
 printf("\nTransmitted codeword:\n");
 for (int i = 1; i <= 11; i++)
 printf("%d ", h[i]);
}
void make_error() {
 int pos;
 printf("\nEnter position to introduce error (1-11): ");
 scanf("%d", &pos);
 if (pos < 1 || pos > 11) {
 printf("Invalid position\n");
 return;
 }
 h[pos] ^= 1;
 printf("Erroneous codeword:\n");
 for (int i = 1; i <= 11; i++)
 printf("%d ", h[i]);
}
void correct_error() {
 int r1 = (h[1]+h[3]+h[5]+h[7]+h[9]+h[11]) % 2;
 int r2 = (h[2]+h[3]+h[6]+h[7]+h[10]+h[11]) % 2;
 int r4 = (h[4]+h[5]+h[6]+h[7]) % 2;
 int r8 = (h[8]+h[9]+h[10]+h[11]) % 2;
 int pos = r8 * 8 + r4 * 4 + r2 * 2 + r1;
 printf("\nError position: %d\n", pos);
 if (pos >= 1 && pos <= 11)
 h[pos] ^= 1;
 printf("Corrected codeword:\n");
 for (int i = 1; i <= 11; i++)
 printf("%d ", h[i]);
}
int main() {
 int choice;
 printf("Enter 7 data bits: ");
 for (int i = 1; i <= 11; i++)
 if (i == 3 || i == 5 || i == 6 || i == 7 ||
 i == 9 || i == 10 || i == 11)
 scanf("%1d", &h[i]);
 generate();
 printf("\nIntroduce an error? (1 = Yes, 0 = No): ");
 scanf("%d", &choice);
 if (choice) {
 make_error();
 correct_error();
 } else {
 printf("\nNo error introduced.\n");
 }
 return 0;
}
__CODE_END__
    done_msg "a5_hamming.c   (compile: gcc a5_hamming.c -o a5)"
}

a6() {
    make_dir
    cat > "$DIR/a6_sliding_sender.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
int main() {
 int sock, client, len, i = 1;
 char frame[30], ack[30];
 struct sockaddr_in addr = {0};
 sock = socket(AF_INET, SOCK_STREAM, 0);
 if (sock < 0) {
 perror("Socket");
 return 1;
 }
 addr.sin_family = AF_INET;
 addr.sin_port = htons(17000);
 addr.sin_addr.s_addr = INADDR_ANY;
 if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0 ||
 listen(sock, 5) < 0) {
 perror("Bind/Listen");
 return 1;
 }
 printf("Waiting for receiver...\n");
 len = sizeof(addr);
 client = accept(sock, (struct sockaddr *)&addr, (socklen_t *)&len);
 while (1) {
 printf("Enter Data Frame %d (exit to end): ", i);
 scanf("%29s", frame);
 send(client, frame, strlen(frame) + 1, 0);
 if (strcmp(frame, "exit") == 0)
 break;
 int n = recv(client, ack, sizeof(ack) - 1, 0);
 if (n <= 0) break;
 ack[n] = '\0';
 printf("Acknowledgment: %s\n", ack);
 i++;
 }
 close(client);
 close(sock);
 return 0;
}
__CODE_END__
    cat > "$DIR/a6_sliding_receiver.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
int main() {
 int sock, n, i = 1;
 char frame[30];
 struct sockaddr_in addr = {0};
 sock = socket(AF_INET, SOCK_STREAM, 0);
 if (sock < 0) {
 perror("Socket");
 return 1;
 }
 addr.sin_family = AF_INET;
 addr.sin_port = htons(17000);
 addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
 perror("Connect");
 return 1;
 }
 while ((n = recv(sock, frame, sizeof(frame) - 1, 0)) > 0) {
 frame[n] = '\0';
 if (strcmp(frame, "exit") == 0)
 break;
 printf("Frame %d data %s received\n", i++, frame);
 char ack[] = "ACK";
 send(sock, ack, sizeof(ack), 0);
 }
 close(sock);
 return 0;
}
__CODE_END__
    done_msg "a6_sliding_sender.c and a6_sliding_receiver.c"
    echo "Compile: gcc a6_sliding_sender.c -o sender ; gcc a6_sliding_receiver.c -o receiver"
    echo "Run the sender first, then the receiver in a second terminal."
}

a7() {
    make_dir
    cat > "$DIR/a7_fifo_server.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#define FIFO1 "fifo1"
#define FIFO2 "fifo2"
int main() {
 char filename[100], buffer[3000];
 int fd1, fd2, file;
 ssize_t n;
 mkfifo(FIFO1, 0666);
 mkfifo(FIFO2, 0666);
 printf("SERVER ONLINE\nWaiting for request...\n");
 fd1 = open(FIFO1, O_RDONLY);
 n = read(fd1, filename, sizeof(filename) - 1);
 if (n <= 0) {
 perror("Filename read failed");
 return 1;
 }
 filename[n] = '\0';
 file = open(filename, O_RDONLY);
 fd2 = open(FIFO2, O_WRONLY);
 if (file < 0) {
 write(fd2, "File not found!", 15);
 perror("File not found");
 } else {
 printf("Server: %s found\nTransferring contents...\n", filename);
 while ((n = read(file, buffer, sizeof(buffer))) > 0)
 write(fd2, buffer, n);
 close(file);
 printf("Transfer completed\n");
 }
 close(fd1);
 close(fd2);
 return 0;
}
__CODE_END__
    cat > "$DIR/a7_fifo_client.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
int main() {
 char filename[100], buffer[3000];
 int fd1, fd2;
 ssize_t n;
 mkfifo("fifo1", 0666);
 mkfifo("fifo2", 0666);
 printf("Enter filename: ");
 scanf("%99s", filename);
 fd1 = open("fifo1", O_WRONLY);
 write(fd1, filename, strlen(filename));
 close(fd1);
 fd2 = open("fifo2", O_RDONLY);
 printf("\nReceived file contents:\n");
 while ((n = read(fd2, buffer, sizeof(buffer))) > 0)
 fwrite(buffer, 1, n, stdout);
 close(fd2);
 return 0;
}
__CODE_END__
    done_msg "a7_fifo_server.c and a7_fifo_client.c"
    echo "Compile: gcc a7_fifo_server.c -o server ; gcc a7_fifo_client.c -o client"
    echo "Run the server in one terminal and the client in another."
}

a8() {
    make_dir
    cat > "$DIR/a8_udp_server.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
int main(int argc, char *argv[]) {
 int sock, n;
 char buffer[1024];
 struct sockaddr_in server, client;
 socklen_t len = sizeof(client);
 if (argc != 2) {
 printf("Usage: %s <port>\n", argv[0]);
 return 1;
 }
 sock = socket(AF_INET, SOCK_DGRAM, 0);
 if (sock < 0) {
 perror("Socket");
 return 1;
 }
 memset(&server, 0, sizeof(server));
 server.sin_family = AF_INET;
 server.sin_addr.s_addr = INADDR_ANY;
 server.sin_port = htons(atoi(argv[1]));
 if (bind(sock, (struct sockaddr *)&server, sizeof(server)) < 0) {
 perror("Bind");
 return 1;
 }
 while (1) {
 n = recvfrom(sock, buffer, sizeof(buffer) - 1, 0, (struct sockaddr *)&client, &len);
 if (n < 0) {
 perror("Receive");
 continue;
 }
 buffer[n] = '\0';
 printf("Received a datagram: %s", buffer);
 sendto(sock, "Got your message\n", 17, 0, (struct sockaddr *)&client, len);
 }
 close(sock);
 return 0;
}
__CODE_END__
    cat > "$DIR/a8_udp_client.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
int main(int argc, char *argv[]) {
 int sock, n;
 char buffer[256];
 struct sockaddr_in server;
 socklen_t len = sizeof(server);
 if (argc != 3) {
 printf("Usage: %s <hostname> <port>\n", argv[0]);
 return 1;
 }
 sock = socket(AF_INET, SOCK_DGRAM, 0);
 if (sock < 0) {
 perror("Socket");
 return 1;
 }
 memset(&server, 0, sizeof(server));
 server.sin_family = AF_INET;
 server.sin_port = htons(atoi(argv[2]));
 if (inet_pton(AF_INET, argv[1], &server.sin_addr) != 1) {
 printf("Use an IPv4 address such as 127.0.0.1\n");
 return 1;
 }
 printf("Please enter the message: ");
 fgets(buffer, sizeof(buffer), stdin);
 sendto(sock, buffer, strlen(buffer), 0, (struct sockaddr *)&server, len);
 n = recvfrom(sock, buffer, sizeof(buffer) - 1, 0, NULL, NULL);
 if (n < 0) {
 perror("Receive acknowledgment");
 return 1;
 }
 buffer[n] = '\0';
 printf("Got an ack: %s", buffer);
 close(sock);
 return 0;
}
__CODE_END__
    done_msg "a8_udp_server.c and a8_udp_client.c"
    echo "Compile: gcc a8_udp_server.c -o server ; gcc a8_udp_client.c -o client"
    echo "Run: ./server 8080   then   ./client 127.0.0.1 8080"
}

a9() {
    make_dir
    cat > "$DIR/a9_leaky_bucket.c" <<'__CODE_END__'
#include <stdio.h>
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX 25
int main() {
 int cap, rate, packets[MAX], n = 0, choice;
 int content = 0, dropped, i;
 printf("LEAKY BUCKET ALGORITHM\n");
 printf("Enter the bucket size:\n");
 scanf("%d", &cap);
 printf("Enter the output rate:");
 scanf("%d", &rate);
 do {
 printf("Enter packets entering at %d seconds\n", n + 1);
 scanf("%d", &packets[n++]);
 printf("Enter 1 to insert packet or 0 to quit\n");
 scanf("%d", &choice);
 } while (choice && n < MAX);
 printf("\n(SECOND):(PACK RECVD):(PACK SENT):(PACK LEFT):(PACK DROPPED)\n");
 for (i = 0; i < n || content > 0; i++) {
 int received = (i < n) ? packets[i] : 0;
 content += received;
 dropped = 0;
 if (content > cap) {
 dropped = content - cap;
 content = cap;
 }
 int sent = MIN(content, rate);
 content -= sent;
 printf("(%d):\t(%d):\t(%d):\t(%d):\t(%d)\n", i + 1, received, sent, content, dropped);
 }
 return 0;
}
__CODE_END__
    done_msg "a9_leaky_bucket.c   (compile: gcc a9_leaky_bucket.c -o a9)"
}

a10() {
    make_dir
    cat > "$DIR/a10_dns.c" <<'__CODE_END__'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <arpa/inet.h>
int main()
{
 char hostname[100];
 struct hostent *host;
 struct in_addr **addr_list;
 printf("Enter the domain name: ");
 scanf("%99s", hostname);
 host = gethostbyname(hostname);
 if (host == NULL) {
 printf("DNS lookup failed.\n");
 return 1;
 }
 printf("\nHost Name: %s\n", host->h_name);
 printf("IP Address: ");
 addr_list = (struct in_addr **)host->h_addr_list;
 if (addr_list[0] != NULL)
 printf("%s\n", inet_ntoa(*addr_list[0]));
 return 0;
}
__CODE_END__
    done_msg "a10_dns.c   (compile: gcc a10_dns.c -o a10)"
}

# ---------------------------------------------------------------- PART B

b1() {
    make_dir
    cat > "$DIR/b1_lab1.tcl" <<'__CODE_END__'
set ns [ new Simulator ]
set tf [ open lab1.tr w ]
$ns trace-all $tf
set nf [ open lab1.nam w ]
$ns namtrace-all $nf
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$ns color 1 "red"
$ns color 2 "blue"
$n0 label "Source/udp0"
$n1 label "Source/udp1"
$n2 label "Router"
$n3 label "Destination/Null"
$ns duplex-link $n0 $n2 10Mb 300ms DropTail
$ns duplex-link $n1 $n2 10Mb 300ms DropTail
$ns duplex-link $n2 $n3 1Mb 300ms DropTail
$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n2 $n3 5
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$udp0 set class_ 1
$udp1 set class_ 2
$ns connect $udp0 $null3
$ns connect $udp1 $null3
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
proc finish { } {
 global ns nf tf
 $ns flush-trace
 exec nam lab1.nam &
 close $tf
 close $nf
 exit 0
}
$ns at 0.1 "$cbr0 start"
$ns at 0.1 "$cbr1 start"
$ns at 10.0 "finish"
$ns run
__CODE_END__
    cat > "$DIR/b1_lab1.awk" <<'__CODE_END__'
BEGIN{
count=0
}
{
 if($1=="d")
 count++
}
END{
printf("The Total no of Packets Dropped due to Congestion : %d\n\n", count)
}
__CODE_END__
    done_msg "b1_lab1.tcl and b1_lab1.awk"
    echo "Run: ns b1_lab1.tcl   then   awk -f b1_lab1.awk lab1.tr"
}

b2() {
    make_dir
    cat > "$DIR/b2_lab2.tcl" <<'__CODE_END__'
set ns [new Simulator]
set tf [open lab2.tr w]
$ns trace-all $tf
set nf [open lab2.nam w]
$ns namtrace-all $nf
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$ns color 1 "red"
$ns color 2 "blue"
$n0 label "source/TCP"
$n1 label "source/UDP"
$n2 label "Router"
$n3 label "destination"
$ns duplex-link $n0 $n2 100Mb 1ms DropTail
$ns duplex-link $n1 $n2 100Mb 1ms DropTail
$ns duplex-link $n2 $n3 100Mb 1ms DropTail
$ns duplex-link-op $n0 $n2 color "green"
$ns duplex-link-op $n0 $n2 label "from 0-2"
$ns duplex-link-op $n1 $n2 color "green"
$ns duplex-link-op $n1 $n2 label "from 1-2"
$ns duplex-link-op $n2 $n3 color "green"
$ns duplex-link-op $n2 $n3 label "from 2-3"
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3
$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.001
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.001
$tcp0 set class_ 1
$udp1 set class_ 2
$ns connect $tcp0 $sink3
$ns connect $udp1 $null3
proc finish { } {
global ns nf tf
$ns flush-trace
exec nam lab2.nam &
close $nf
close $tf
exit 0
}
$ns at 0.1 "$cbr1 start"
$ns at 0.2 "$ftp0 start"
$ns at 5.0 "finish"
$ns run
__CODE_END__
    cat > "$DIR/b2_lab2.awk" <<'__CODE_END__'
BEGIN{
tcp=0;
udp=0;
}
{
 if($1=="r"&&$3=="2"&&$4=="3"&& $5=="tcp")
 tcp++;
 if($1=="r"&&$3=="2"&&$4=="3"&&$5=="cbr")
 udp++;
}
END{
printf("\n Total number of packets sent by TCP : %d\n",tcp);
printf("\n Total number of packets sent by UDP : %d\n",udp);
}
__CODE_END__
    done_msg "b2_lab2.tcl and b2_lab2.awk"
    echo "Run: ns b2_lab2.tcl   then   awk -f b2_lab2.awk lab2.tr"
}

b3() {
    make_dir
    cat > "$DIR/b3_lab3.tcl" <<'__CODE_END__'
set ns [new Simulator]
set trace_file [open lab3.tr w]
$ns trace-all $trace_file
set nam_file [open lab3.nam w]
$ns namtrace-all $nam_file
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
$n0 label "Ping0"
$n4 label "Ping4"
$n1 label "Ping1"
$n5 label "Ping5"
$ns color 1 "blue"
$ns color 2 "orange"
$ns duplex-link $n0 $n2 0.5mb 10ms DropTail
$ns duplex-link $n1 $n2 0.5mb 10ms DropTail
$ns duplex-link $n2 $n3 0.5mb 10ms DropTail
$ns duplex-link $n3 $n4 0.5mb 10ms DropTail
$ns duplex-link $n3 $n5 0.5mb 10ms DropTail
set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0
set ping4 [new Agent/Ping]
$ns attach-agent $n4 $ping4
set ping1 [new Agent/Ping]
$ns attach-agent $n1 $ping1
set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5
$ping0 set packetSize_ 500
$ping0 set interval_ 0.001
$ping1 set packetSize_ 500
$ping1 set interval_ 0.001
$ping4 set packetSize_ 500
$ping4 set interval_ 0.001
$ping5 set packetSize_ 500
$ping5 set interval_ 0.001
set udp0 [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp0
$ns attach-agent $n4 $null
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 512
$cbr set interval_ 0.001
$cbr attach-agent $udp0
$ns connect $udp0 $null
$ping0 set class_ 1
$ping1 set class_ 2
$ns connect $ping0 $ping4
$ns connect $ping1 $ping5
Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts " The node [$node_ id] received a reply from $from with round trip time of $rtt ms"
}
proc finish { } {
global ns nam_file trace_file
$ns flush-trace
exec nam lab3.nam &
close $trace_file
close $nam_file
exit 0
}
$ns at 0.1 "$ping0 send"
$ns at 0.2 "$ping0 send"
$ns at 0.3 "$ping0 send"
$ns at 0.4 "$ping0 send"
$ns at 0.5 "$ping0 send"
$ns at 0.6 "$ping0 send"
$ns at 0.7 "$ping0 send"
$ns at 0.8 "$ping0 send"
$ns at 0.9 "$ping0 send"
$ns at 1.0 "$ping0 send"
$ns at 0.2 "$cbr start"
$ns at 4.0 "$cbr stop"
$ns at 0.1 "$ping1 send"
$ns at 0.2 "$ping1 send"
$ns at 0.3 "$ping1 send"
$ns at 0.4 "$ping1 send"
$ns at 0.5 "$ping1 send"
$ns at 0.6 "$ping1 send"
$ns at 0.7 "$ping1 send"
$ns at 0.8 "$ping1 send"
$ns at 0.9 "$ping1 send"
$ns at 1.0 "$ping1 send"
$ns at 5.5 "finish"
$ns run
__CODE_END__
    cat > "$DIR/b3_lab3.awk" <<'__CODE_END__'
BEGIN{
count=0
}
{
 if($1=="d")
 count++
}
END{
 printf("The Total no of Packets Dropped due toCongestion:%d ", count)
}
__CODE_END__
    done_msg "b3_lab3.tcl and b3_lab3.awk"
    echo "Run: ns b3_lab3.tcl   then   awk -f b3_lab3.awk lab3.tr"
}

b4() {
    make_dir
    cat > "$DIR/b4_lab4.tcl" <<'__CODE_END__'
set ns [new Simulator]
set tf [open lab4.tr w]
$ns trace-all $tf
set nf [open lab4.nam w]
$ns namtrace-all $nf
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$ns make-lan "$n0 $n1 $n2 $n3" 10mb 10ms LL Queue/DropTail Mac/802_3
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp0 $sink3
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp2 $sink1
set file1 [open file1.tr w]
$tcp0 attach $file1
$tcp0 trace cwnd_
$tcp0 set maxcwnd_ 10
set file2 [open file2.tr w]
$tcp2 attach $file2
$tcp2 trace cwnd_
proc finish { } {
global nf tf ns
$ns flush-trace
exec nam lab4.nam &
close $nf
close $tf
exit 0
}
$ns at 0.1 "$ftp0 start"
$ns at 1.5 "$ftp0 stop"
$ns at 2 "$ftp0 start"
$ns at 3 "$ftp0 stop"
$ns at 0.2 "$ftp2 start"
$ns at 2 "$ftp2 stop"
$ns at 2.5 "$ftp2 start"
$ns at 4 "$ftp2 stop"
$ns at 5.0 "finish"
$ns run
__CODE_END__
    cat > "$DIR/b4_lab4.awk" <<'__CODE_END__'
BEGIN{
}
{
if($6=="cwnd_")
 printf("%f \t %f \n", $1,$7);
}
END{
puts "DONE"
}
__CODE_END__
    done_msg "b4_lab4.tcl and b4_lab4.awk"
    echo "Run: ns b4_lab4.tcl"
    echo "     awk -f b4_lab4.awk file1.tr > tcp1 ; awk -f b4_lab4.awk file2.tr > tcp2"
    echo "     xgraph -x \"time\" -y \"convalue\" tcp1 tcp2"
}

b5() {
    make_dir
    cat > "$DIR/b5_lab5.tcl" <<'__CODE_END__'
set ns [new Simulator]
set tf [open lab5.tr w]
$ns trace-all $tf
set nf [open lab5.nam w]
$ns namtrace-all $nf
$ns color 1 "red"
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
$n1 label "Source/UDP"
$n3 label "Error Node"
$n5 label "Destination"
$ns make-lan "$n0 $n1 $n2 $n3" 10Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n4 $n5 $n6" 10Mb 10ms LL Queue/DropTail Mac/802_3
$ns duplex-link $n3 $n6 100Mb 10ms DropTail
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [ new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
set null5 [new Agent/Null]
$ns attach-agent $n5 $null5
$ns connect $udp1 $null5
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.0001
$udp1 set class_ 1
set err [new ErrorModel]
$ns lossmodel $err $n3 $n6
$err set rate_ 0.2
proc finish { } {
global nf ns tf
exec nam lab5.nam &
close $nf
close $tf
exit 0
}
$ns at 5.0 "finish"
$ns at 0.1 "$cbr1 start"
$ns run
__CODE_END__
    cat > "$DIR/b5_lab5.awk" <<'__CODE_END__'
BEGIN{
pkt=0;
time=0
}
{
 if($1=="r" && $3=="8" && $4=="5")
 {
 pkt=pkt+$6
 time=$2
 }
}
END{
 printf(" Throughput: %fMbps\n\n",(pkt/time)*(8/1000000));
}
__CODE_END__
    done_msg "b5_lab5.tcl and b5_lab5.awk"
    echo "Run: ns b5_lab5.tcl   then   awk -f b5_lab5.awk lab5.tr"
}

# ---------------------------------------------------------------- MENU

echo "=============================================="
echo "      LAB PROGRAM GENERATOR"
echo "=============================================="
echo "Pick a program. Its code will be written into ./$DIR/"
echo

PS3=$'\nEnter your choice number: '

options=(
    "A1  - Dijkstra's shortest path (6-10 nodes)"
    "A2  - Error detection using CRC-CCITT (16-bit)"
    "A3  - Distance vector algorithm"
    "A4  - TCP client-server file transfer"
    "A5  - Error detection using Hamming code"
    "A6  - Sliding window protocol"
    "A7  - FIFO client-server file transfer"
    "A8  - UDP client-server file transfer"
    "A9  - Leaky bucket congestion control"
    "A10 - DNS"
    "B1  - NS2: 3-node network, packet drops"
    "B2  - NS2: 4-node TCP/UDP packet count"
    "B3  - NS2: 6-node ping, packet drops"
    "B4  - NS2: Ethernet LAN, congestion window"
    "B5  - NS2: Ethernet LAN, throughput"
    "Quit"
)

select opt in "${options[@]}"; do
    case "$REPLY" in
        1)  a1 ;;
        2)  a2 ;;
        3)  a3 ;;
        4)  a4 ;;
        5)  a5 ;;
        6)  a6 ;;
        7)  a7 ;;
        8)  a8 ;;
        9)  a9 ;;
        10) a10 ;;
        11) b1 ;;
        12) b2 ;;
        13) b3 ;;
        14) b4 ;;
        15) b5 ;;
        16) echo "Bye!"; break ;;
        *)  echo "Invalid choice, enter a number from 1 to 16." ;;
    esac
    echo
done
