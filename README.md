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

## 2.4.5-p1
```
docker run -p 2451:2451 -it --rm zunsakai/magento:m2-ce-2.4.5-p1 bash
```

## 2.4.5
```
docker run -p 2450:2450 -it --rm zunsakai/magento:m2-ce-2.4.5 bash
```

# Custom base url
Use `HOST` and `PORT` to define custom base url. Make sure you have added it in the hosts file.
```
docker run -e HOST=magento.local -e PORT=3000 -p 3000:3000 -it --rm zunsakai/magento:m2-ce-2.4.5 bash
```

# Aliases
-   `bm`: bin/magento
-   `n98`: n98-magerun2.phar
