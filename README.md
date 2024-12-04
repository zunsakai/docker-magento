# Magento instant

Welcome to the hassle-free Magento experience! This Docker image provides a seamless Magento environment, allowing you to run Magento directly without the need for additional installations or configurations. With pre-configured settings and dependencies, this image simplifies the setup process, making it quick and straightforward to deploy your Magento applications.

Key Features:

-   Ready-to-run Magento environment.
-   No additional installations required.
-   Pre-configured settings and dependencies.
-   Ideal for development, testing.

Get started with Magento effortlessly by pulling this Docker image and kickstart your e-commerce projects without the complexity of manual configurations. Dive into Magento development with confidence, focusing on building your online store while leaving the setup worries behind.

Docker hub: https://hub.docker.com/r/zunsakai/magento

# Get this image

To use this Docker image, simply pull it from Docker Hub using the following command:

```
docker run -p [PORT]:[PORT] -it --rm zunsakai/magento:m2-ce-[VERSION-[PATCH]] bash
```

Ports
| Version     | PORT   |
| ---------   | ------ |
| 2.4.5       | 2450   |
| 2.4.5-p1    | 2451   |
| 2.4.5-p2    | 2452   |
| 2.4.5-p3    | 2453   |
| 2.4.5-p4    | 2454   |
| 2.4.5-p5    | 2455   |
| 2.4.5-p6    | 2456   |
| 2.4.5-p7    | 2457   |
| 2.4.5-p8    | 2458   |
| 2.4.5-p9    | 2459   |
| 2.4.5-p10   | 24510  |
| 2.4.6       | 2460   |
| 2.4.6-p1    | 2461   |
| 2.4.6-p2    | 2462   |
| 2.4.6-p3    | 2463   |
| 2.4.6-p4    | 2464   |
| 2.4.6-p5    | 2465   |
| 2.4.6-p6    | 2466   |
| 2.4.6-p7    | 2467   |
| 2.4.6-p8    | 2468   |
| 2.4.7       | 2470   |
| 2.4.7-p1    | 2471   |
| 2.4.7-p2    | 2472   |
| 2.4.7-p3    | 2473   |
| 2.4.8-beta1 | 2480 |


Example

```
docker run -p 2473:2473 -it --rm zunsakai/magento:m2-ce-2.4.7-p3 bash
```

# Custom base url

Use `HOST` and `PORT` to define custom base url. Make sure you have added it in the hosts file.

```
docker run -e HOST=magento.local -e PORT=3000 -p 3000:3000 -it --rm zunsakai/magento:m2-ce-2.4.5 bash
```

# Aliases

-   `bm`: bin/magento
-   `n98`: n98-magerun2.phar
