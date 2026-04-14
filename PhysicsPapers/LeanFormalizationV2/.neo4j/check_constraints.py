#!/usr/bin/env python3
from neo4j import GraphDatabase

driver = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j', 'omegatheory2026'))
with driver.session() as session:
    print('Constraints:')
    for rec in session.run("SHOW CONSTRAINTS"):
        print(f"  {rec}")
driver.close()
