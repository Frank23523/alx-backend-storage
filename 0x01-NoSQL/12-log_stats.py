#!/usr/bin/env python3
"""Log stats"""

from pymongo import MongoClient


def log_stats(nginx_collection):
    """
    Provides stats about Nginx logs stored in MongoDB
    """
    print('{} logs'.format(nginx_collection.count_documents({})))
    print('Methods:')
    methods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']
    for method in methods:
        req_count = nginx_collection.count_documents({'method': method})
        print('\tmethod {}: {}'.format(method, req_count))
    status_checks_count = nginx_collection.count_documents(
        {'method': 'GET', 'path': '/status'}
    )
    print('{} status check'.format(status_checks_count))

    print('IPs:')
    pipeline = [
        {"$group": {"_id": "$ip", "count": {"$sum": 1}}},
        {"$sort": {"count": -1}},
        {"$limit": 10}
    ]
    top_ips = nginx_collection.aggregate(pipeline)
    for ip_info in top_ips:
        print('\t{}: {}'.format(ip_info['_id'], ip_info['count']))


def run():
    '''Provides some stats about Nginx logs stored in MongoDB.
    '''
    client = MongoClient('mongodb://127.0.0.1:27017')
    log_stats(client.logs.nginx)


if __name__ == '__main__':
    run()
