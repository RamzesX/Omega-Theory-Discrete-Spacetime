#!/usr/bin/env python3
"""
Relax the Theorem uniqueness constraint from (namespace, name) to
(namespace, name, file) so collisions across files (actionDensity_pos
in Predictions and Irrationality/ActionDensity) can coexist.

Also add a Definition uniqueness constraint on (namespace, name, file).
"""
from neo4j import GraphDatabase

driver = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j', 'omegatheory2026'))

with driver.session() as session:
    # Drop old theorem constraint
    try:
        session.run("DROP CONSTRAINT omega_theorem_unique")
        print("Dropped old omega_theorem_unique")
    except Exception as e:
        print(f"Drop omega_theorem_unique: {e}")

    # New theorem constraint keyed by (namespace, name, file)
    session.run("""
        CREATE CONSTRAINT omega_theorem_unique_v2 IF NOT EXISTS
        FOR (n:Theorem)
        REQUIRE (n.namespace, n.name, n.file) IS UNIQUE
    """)
    print("Created omega_theorem_unique_v2")

    # Definition constraint keyed similarly
    session.run("""
        CREATE CONSTRAINT omega_def_unique IF NOT EXISTS
        FOR (n:Definition)
        REQUIRE (n.namespace, n.name, n.file) IS UNIQUE
    """)
    print("Created omega_def_unique")

    print('\nFinal constraint list:')
    for rec in session.run("SHOW CONSTRAINTS"):
        lbl = rec['labelsOrTypes']
        props = rec['properties']
        print(f"  {rec['name']:30s} {lbl} {props}")

driver.close()
