FROM plopix/docker-php-ez-engine:7.3

COPY entrypoint.bash /entrypoint.bash
RUN chmod +x /entrypoint.bash
ENTRYPOINT ["/entrypoint.bash"]
CMD ["php-fpm"]
